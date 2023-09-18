// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length prefer_self_in_static_references
// swiftlint:disable type_body_length type_name
internal enum StoryboardScene {
  internal enum Authentification: StoryboardType {
    internal static let storyboardName = "Authentification"

    internal static let initialScene = InitialSceneType<SplashScreenViewController>(storyboard: Authentification.self)

    internal static let addNewReminderViewController = SceneType<AddNewReminderViewController>(storyboard: Authentification.self, identifier: "AddNewReminderViewController")

    internal static let albumDetailsViewController = SceneType<AlbumDetailsViewController>(storyboard: Authentification.self, identifier: "AlbumDetailsViewController")

    internal static let albumsViewController = SceneType<AlbumsViewController>(storyboard: Authentification.self, identifier: "AlbumsViewController")

    internal static let homeViewController = SceneType<HomeViewController>(storyboard: Authentification.self, identifier: "HomeViewController")

    internal static let imageDetailsViewController = SceneType<ImageDetailsViewController>(storyboard: Authentification.self, identifier: "ImageDetailsViewController")

    internal static let loginViewController = SceneType<LoginViewController>(storyboard: Authentification.self, identifier: "LoginViewController")

    internal static let mapViewController = SceneType<MapViewController>(storyboard: Authentification.self, identifier: "MapViewController")

    internal static let registrationViewController = SceneType<RegistrationViewController>(storyboard: Authentification.self, identifier: "RegistrationViewController")

    internal static let settingsViewController = SceneType<SettingsViewController>(storyboard: Authentification.self, identifier: "SettingsViewController")

    internal static let splashScreenViewController = SceneType<SplashScreenViewController>(storyboard: Authentification.self, identifier: "SplashScreenViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length prefer_self_in_static_references
// swiftlint:enable type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
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
