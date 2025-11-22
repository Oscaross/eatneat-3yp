//
//  AppBridge.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/11/2025.
//

import Foundation
import Network
import SwiftUI

@MainActor
class AppBridge: ObservableObject {

    // Published commands -> UI reacts in SwiftUI
    @Published var pendingCommands: [BridgeCommand] = []

    // MARK: - Dev Mode / Prod Mode Config
    let isDevMode: Bool
    private var listener: NWListener?

    init(isDevMode: Bool = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil) {
        self.isDevMode = isDevMode

        if isDevMode {
            startInboundBridgeServer()
        }
    }

    // MARK: - Inbound HTTP Server (Dev Mode)

    private func startInboundBridgeServer() {
        do {
            listener = try NWListener(using: .tcp, on: 9090)
        } catch {
            print("AppBridge Listener failed: \(error)")
            return
        }

        listener?.newConnectionHandler = { [weak self] connection in
            connection.start(queue: .main)

            Task { @MainActor in
                self?.handleIncoming(connection: connection)
            }
        }

        listener?.start(queue: .main)
        print("AppBridge listening on http://127.0.0.1:9090")
    }
    @MainActor
    private func handleIncoming(connection: NWConnection) {
        connection.receiveMessage { [weak self] data, _, _, _ in
            guard let self = self else { return }
            guard let data = data else { return }

            // Extract entire raw request
            guard let rawPacket = String(data: data, encoding: .utf8) else { return }

            // Separate HTTP headers from JSON body
            let jsonBody = rawPacket
                .components(separatedBy: "\r\n\r\n")
                .last?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            // Convert JSON body into Data
            guard let payload = jsonBody.data(using: .utf8) else { return }

            // Decode command
            if let command = try? JSONDecoder().decode(BridgeCommand.self, from: payload) {
                self.pendingCommands.append(command)
            }

            // Respond to HTTP client
            let ok = "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"
            connection.send(content: ok.data(using: .utf8), completion: .contentProcessed { _ in })
            connection.cancel()
        }
    }

    // MARK: - Outbound (Prod Mode)
    func sendToCloud(action: String, payload: [String: Any]) async throws {
        guard let url = URL(string: "https://mcp.myserver.com/\(action)") else { return }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let _ = try await URLSession.shared.data(for: req)
    }

    // MARK: - Callbacks for SwiftUI
    func consumeCommand(_ command: BridgeCommand) {
        if let idx = pendingCommands.firstIndex(where: { $0.id == command.id }) {
            pendingCommands.remove(at: idx)
        }
    }
}

// MARK: - Command Payloads

struct BridgeCommand: Codable, Identifiable {
    let id = UUID()
    let action: String
    let message: String?
}
