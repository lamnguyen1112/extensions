//
//  UIApplication+Extension.swift
//  Template
//
//  Created by Lam Nguyen on 4/23/22.
//
#if !os(macOS)
    import UIKit

    public extension UIApplication {
        static var appVersion: String {
            return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0.0"
        }

        static var appBuild: String {
            return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? "1"
        }

        static var appVersionBuild: String {
            return "v\(appVersion)(\(appBuild))"
        }

        static var delegateKeyWindow: UIWindow? { return shared.delegate?.window ?? nil }

        static var statusBarView: UIView? {
            return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        }

        static var appKeyWindow: UIWindow? {
            return delegateKeyWindow ?? keyWindowOrFirst
        }

        static var keyWindowOrFirst: UIWindow? {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.windows.first
            } else {
                return UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first
            }
        }
    }

    public extension UIApplication {
        class var rootViewController: UIViewController? { return shared.delegate?.window??.rootViewController }

        class var topMostViewController: UIViewController? {
            return rootViewController?.topMostViewController
        }

        class var visibleMostViewController: UIViewController? {
            return rootViewController?.visibleMostViewController
        }

        static func switchRootViewController(to newRootViewController: UIViewController, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
            guard let window = appKeyWindow else {
                completion?(false)
                return
            }

            guard animated else {
                window.rootViewController = newRootViewController
                window.makeKeyAndVisible()
                completion?(true)
                return
            }

            window.rootViewController = newRootViewController
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: { _ in
                                  completion?(true)
                              })
        }
    }

    public extension UIApplication {
        static func canOpen(url string: String) -> Bool {
            guard let url = URL(string: string) else { return false }
            return shared.canOpenURL(url)
        }

        static func openUrlString(_ urlString: String?) {
            if let stringUrl = urlString, let url = URL(string: stringUrl) {
                if #available(iOS 10.0, *) {
                    self.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    _ = shared.openURL(url)
                }
            }
        }
    }
#endif
