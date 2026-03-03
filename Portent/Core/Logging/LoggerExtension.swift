import OSLog

extension Logger {
    static func forType<T>(_ type: T.Type) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.notitial.portent", category: String(describing: type))
    }
}

protocol Loggable {
    var logger: Logger { get }
    func logEvent(_ message: String)
    func logError(_ message: String)
}

extension Loggable {
    func logEvent(_ message: String, params: [String: String]) {
        logger.debug("\(message) — \(params.description)")
    }
    func logError(_ message: String, error: Error) {
        logger.error("\(message): \(error.localizedDescription)")
    }
}
