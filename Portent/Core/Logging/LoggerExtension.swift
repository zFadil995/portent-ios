import OSLog

extension Logger {
    static func forType<T>(_ type: T.Type) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.portent", category: String(describing: type))
    }
}

protocol Loggable {
    var logger: Logger { get }
    func logEvent(_ message: String)
    func logError(_ message: String)
}
