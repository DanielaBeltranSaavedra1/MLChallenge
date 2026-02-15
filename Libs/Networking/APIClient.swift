import Foundation
import Combine
import os

public final class APIClient {

    public static let shared = APIClient()

    private init() {}

    private let baseURL = "https://api.mercadolibre.com"
    private let logger = Logger(subsystem: "com.yourapp.APIClient", category: "APIClient")

    public func request<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        method: String = "GET"
    ) async throws -> T {

        guard var components = URLComponents(string: baseURL + path) else {
            logger.error("Invalid URL for path: \(path)")
            throw APIError.invalidURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            logger.error("Invalid URL components: \(components)")
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.timeoutInterval = 30

        logger.debug("Request: \(request.url?.absoluteString ?? "nil")")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            logger.error("Invalid response type")
            throw APIError.invalidResponse
        }

        logger.debug("Response Status: \(http.statusCode)")

        // Handle 403 Forbidden by returning mock data
        if http.statusCode == 403 {
            logger.warning("Received 403, falling back to MockAPIClient")
            return try await MockAPIClient.shared.request(path: path, queryItems: queryItems, method: method)
        }

        guard 200..<300 ~= http.statusCode else {
            logger.error("HTTP Error: \(http.statusCode)")
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw APIError.decoding(error)
        }
    }
}
