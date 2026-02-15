//
//  UI.swift
//  AppUIKit
//
//  Created by Aleksandr Lis on 16.02.2026.
//

import UIKit

public enum UI {
    public enum Font {
        public static let header: UIFont = .systemFont(ofSize: 34, weight: .bold)
        public static let body: UIFont = .systemFont(ofSize: 16, weight: .medium)
        public static let footer: UIFont = .systemFont(ofSize: 12)
    }

    public enum Color {
        public static let baseBackground = UIColor(hex: 0x040404)
        public static let textRegular = UIColor(hex: 0xF4F4F4)
        public static let textSecondary = UIColor(hex: 0x4D555E)
        public static let textDisabled = UIColor(hex: 0xF4F4F4).withAlphaComponent(0.5)
        public static let textPlaceholder = UIColor(hex: 0x272729)
        public static let brandPrimary = UIColor(hex: 0xFED702)
    }

    public enum Image {
        public static let circle = UIImage(systemName: "circle")
        public static let checkmarkCircle = UIImage(systemName: "checkmark.circle")
        public static let squareAndPencil = UIImage(systemName: "square.and.pencil")
    }
}
