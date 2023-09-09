// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Cancel
  internal static let alertButtonTitleCancel = L10n.tr("Localizable", "alert_button_title_cancel", fallback: "Cancel")
  /// Ok
  internal static let alertButtonTitleOk = L10n.tr("Localizable", "alert_button_title_ok", fallback: "Ok")
  /// It seems there is no Internet connection. Please check your settings and try again.
  internal static let alertMessageNoInternet = L10n.tr("Localizable", "alert_message_no_internet", fallback: "It seems there is no Internet connection. Please check your settings and try again.")
  /// Alert
  internal static let alertTitleAlert = L10n.tr("Localizable", "alert_title_alert", fallback: "Alert")
  /// Localizable.strings
  ///   BIT Reminder
  /// 
  ///   Created by Branislav Manojlovic on 6.9.23..
  internal static let alertTitleError = L10n.tr("Localizable", "alert_title_error", fallback: "Error")
  /// No Internet
  internal static let alertTitleNoInternet = L10n.tr("Localizable", "alert_title_no_internet", fallback: "No Internet")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
