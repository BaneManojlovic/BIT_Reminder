//
//  PrivacyPolicyViewController.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 20.9.23..
//

import UIKit
import WebKit
import KRProgressHUD

class PrivacyPolicyViewController: BaseNavigationController {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        self.loadPage(urlAdress: Constants.privacyPolicyURL)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KRProgressHUD.dismiss()
    }

    func setupUI() {
        self.title = L10n.titleLabelPrivacyPolicy
    }

    func loadPage(urlAdress: String) {
        KRProgressHUD.show()
        DispatchQueue.main.async {
//            guard let url = URL(string: urlAdress) else { return }
            let url = NSURL(string: urlAdress)
            let request = URLRequest(url: url! as URL)
//            let request = NSURLRequest.
            self.webView.load(request)
        }
    }
    
    
}

// MARK: - Conforming to UIScrollViewDelegate

extension PrivacyPolicyViewController: UIScrollViewDelegate {

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

// MARK: - Conforming to WKNavigationDelegate

extension PrivacyPolicyViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("Error")
//        self.handleAPIError(APIError.noInternet, noInternetHandler: {
//            self.loadPage(urlAdress: self.screenType.urlAdress)
//        })
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
//        let credential = URLCredential(trust: serverTrust)
//        completionHandler(.useCredential, credential)
        DispatchQueue.global().async {
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var frame = webView.frame
        frame.size.height = webView.scrollView.contentSize.height
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSize.init(width: 0, height: 0))
        frame.size = fittingSize
        webView.frame = frame
    }
}
