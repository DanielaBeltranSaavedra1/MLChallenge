public enum APIError: Error {
    case invalidURL
    case invalidResponse
    case forbidden
    case decoding(Error)
}
