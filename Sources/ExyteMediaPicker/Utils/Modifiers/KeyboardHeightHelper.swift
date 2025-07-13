//
//  KeyboardHeightHelper.swift
//  Example-iOS
//
//  Created by Alisa Mylnikova on 23.08.2023.
//

import SwiftUI

#if compiler(>=6.0)
extension Notification: @retroactive @unchecked Sendable { }
#else
extension Notification: @unchecked Sendable { }
#endif

@MainActor
class KeyboardHeightHelper: ObservableObject {
    static let shared = KeyboardHeightHelper()

    @Published var keyboardHeight: CGFloat = 0
    @Published var keyboardDisplayed: Bool = false

    private init() {
        listenForKeyboardNotifications()
    }

    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self,
                  let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }

            if self.keyboardHeight != keyboardRect.height {
                self.keyboardHeight = keyboardRect.height
            }
            self.keyboardDisplayed = true
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.keyboardHeight = 0
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.keyboardDisplayed = false
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
