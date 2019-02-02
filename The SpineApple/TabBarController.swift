//
//  TabBarController.swift
//  The SpineApple
//
//  Created by Teodor Stanishev on 2.02.19.
//  Copyright © 2019 THESPINEAPPLE. All rights reserved.
//

import UIKit
import WebKit



class TabBarController: UITabBarController , UITabBarControllerDelegate{

    var numOfClickOnEasterEgg:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
        tabBarController?.viewControllers?.forEach { let _ = $0.view }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is MainViewController{
            numOfClickOnEasterEgg += 1
            if(numOfClickOnEasterEgg == 10){
                print("Easter egg begin")
                startEasterEgg()
            }
        }else{
            numOfClickOnEasterEgg = 0
        }
    }
    
    
    func startEasterEgg(){
        let currectViewFrame = self.view.frame
        let frame : CGRect = currectViewFrame
        let easterEggView : UIView = UIView(frame: frame)
        let easterWebView = WKWebView()
        easterWebView.frame = currectViewFrame
        easterWebView.load(URLRequest(url: Bundle.main.url(forResource: "index", withExtension:"html", subdirectory: "EasterEgg")! as URL) as URLRequest)
        easterEggView.addSubview(easterWebView)
        
        
        self.view.addSubview(easterEggView)
    }
}
