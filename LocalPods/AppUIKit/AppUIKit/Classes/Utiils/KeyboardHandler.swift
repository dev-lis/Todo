//
//  KeyboardHandler.swift
//  Todo
//

import UIKit

public final class KeyboardHandler {

    private let scrollView: UIScrollView
    private let view: UIView
    private var observers: [NSObjectProtocol] = []

    public init(scrollView: UIScrollView, view: UIView) {
        self.scrollView = scrollView
        self.view = view
    }

    deinit {
        stopObserving()
    }

    public func startObserving() {
        stopObserving()
        let show = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboardShow(notification)
        }
        let hide = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboardHide(notification)
        }
        observers = [show, hide]
    }

    public func stopObserving() {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers = []
    }

    private func handleKeyboardShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let overlap = view.bounds.maxY - keyboardFrameInView.minY
        let inset = max(0, overlap)

        let curve = UIView.AnimationCurve(rawValue: Int(curveValue)) ?? .easeInOut
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            self?.scrollView.contentInset.bottom = inset
            self?.scrollView.verticalScrollIndicatorInsets.bottom = inset
        }
        animator.startAnimation()
    }

    private func handleKeyboardHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let curve = UIView.AnimationCurve(rawValue: Int(curveValue)) ?? .easeInOut
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            self?.scrollView.contentInset.bottom = 0
            self?.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
        animator.startAnimation()
    }
}
