//
//  ViewController.swift
//  The SpineApp
//
//  Created by Teodor Stanishev on 26.01.19.
//  Copyright © 2019 THESPINEAPPLE. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import Swifter



class MainViewController: UIViewController , WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var spinner: UIView!
    var errorView:UIView!
    var initialURL:URL!
    var server:HttpServer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.initialURL = LocalServer.offlineURL
        self.loadWebView(url: self.initialURL!)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //Set the preffered status bar style in this view
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Default setup for loading the WebView
    private func setup(){
        //Disable 3D touch
        webView.allowsLinkPreview = false
        //
        
        //
        self.webView.scrollView.delegate = self
        //
        
        
        //Start the spiner animation
        spinner = UIViewController.displaySpinner(onView: self.view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        
        //Change the status bar color to math the web app
        setStatusBarBackgroundColor(color: UIColor.init(red:7/255, green:55/255, blue:99/255,alpha:1))
    
    }
    
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        //Remove the spiner after loading the page
        UIViewController.removeSpinner(spinner: spinner)
        LocalServer.sendUUID()
        
    }
    
    //Function to check redirects and loads
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let url = webView.url?.absoluteURL.host
        //Check whether the url is in the app (The Spine app)
        if(url != initialURL?.host){
            print("Opening browser: " , url!)
            let svc = SFSafariViewController(url: webView.url!)
            present(svc, animated: true, completion: nil)
            webView.goBack()
        }
    }
    //

    
    
    
    private func loadWebView(url:URL){
        let myRequest = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.scrollView.bounces = false;
        webView.load(myRequest)
    }
    private func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }

}


extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let image = UIImage(named: "backgroundImage.jpg");
        let imageView = UIImageView(image: image!)
        let screenSize = UIScreen.main.bounds.size;
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle:  .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(imageView)
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    class func displayErrorSplash(onView : UIView) ->UIView{
        let errorView = UIView.init(frame: onView.bounds)
        
        let image = UIImage(named: "errorSplash.jpg");
        let imageView = UIImageView(image: image!)
        let screenSize = UIScreen.main.bounds.size;
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        DispatchQueue.main.async {
            errorView.addSubview(imageView)
            onView.addSubview(errorView)
        }
        return errorView
    }
    class func removeErrorSplash(errorView: UIView){
        DispatchQueue.main.async {
            errorView.removeFromSuperview()
        }
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}


