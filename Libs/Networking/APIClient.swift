import Foundation
import Combine

public final class APIClient {

    public static let shared = APIClient()

    private init() {}

    private let baseURL = "https://api.mercadolibre.com"

    public func request<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        method: String = "GET"
    ) async throws -> T {

        guard var components = URLComponents(string: baseURL + path) else {
            throw APIError.invalidURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.timeoutInterval = 30

        print("[APIClient] Request: \(request.url?.absoluteString ?? "")")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        print("[APIClient] Response Status: \(http.statusCode)")

        // Handle 403 Forbidden by returning mock data
        if http.statusCode == 403 {
            print("[APIClient] Received 403, falling back to MockAPIClient")
            return try await MockAPIClient.shared.request(path: path, queryItems: queryItems, method: method)
        }

        guard 200..<300 ~= http.statusCode else {
            print("[APIClient] HTTP Error: \(http.statusCode)")
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("[APIClient] Decoding error: \(error)")
            throw APIError.decoding(error)
        }
    }
}
