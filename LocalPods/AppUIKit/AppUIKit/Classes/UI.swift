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
        public static let baseBackground = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0x040404)
                : UIColor(hex: 0xF2F2F7)
        }

        public static let secondaryBackground = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0x272729)
                : UIColor(hex: 0xFFFFFF)
        }

        public static let textRegular = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0xF4F4F4)
                : UIColor(hex: 0x1C1C1E)
        }

        public static let textSecondary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0x4D555E)
                : UIColor(hex: 0x6D6D72)
        }

        public static let textDisabled = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0xF4F4F4).withAlphaComponent(0.5)
                : UIColor(hex: 0x1C1C1E).withAlphaComponent(0.5)
        }

        public static let textPlaceholder = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0x272729)
                : UIColor(hex: 0xC7C7CC)
        }

        public static let brandPrimary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: 0xFED702)
                : UIColor(hex: 0xD4A000)
        }
    }

    public enum Image {
        public static let circle = UIImage(systemName: "circle")
        public static let checkmarkCircle = UIImage(systemName: "checkmark.circle")
        public static let squareAndPencil = UIImage(systemName: "square.and.pencil")
        public static let pencil = UIImage(systemName: "pencil")
        public static let squareAndArrowUp = UIImage(systemName: "square.and.arrow.up")
        public static let trash = UIImage(systemName: "trash")
    }
}
