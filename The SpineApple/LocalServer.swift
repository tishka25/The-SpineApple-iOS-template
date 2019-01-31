//
//  Helpers.swift
//  The SpineApp
//
//  Class with helper function for this project
//
//
//  Created by Teodor Stanishev on 26.01.19.
//  Copyright © 2019 THESPINEAPPLE. All rights reserved.
//

import Foundation
import Alamofire
import Zip
import Swifter


class LocalServer{
    
    static var server:HttpServer!
    static var onlineURL = URL(string: "https://thespineapp.com/")
    static var offlineURL = URL(string: "http://localhost:8080")
    
    
    public static func initServer(){
        let path = LocalServer.getDocumentsDirectory().appendingPathComponent("thespineapple").path
        
        server = demoServer(path)
        server["/:path"] = shareFilesFromDirectory(path)
        
        
    }
    public static func startServer(){
        try! server.start(8080)
        print("Server has started on " + (offlineURL?.absoluteString)!);
    }
    public static func stopServer(){
        server.stop()
    }
    
    
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    public static func download(url:String , onFinished: @escaping ()->Void){
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                print("Download Progress: \(progress.fractionCompleted * 100)")
            }).response(completionHandler: { (DefaultDownloadResponse) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                print("Downloaded at: " + (DefaultDownloadResponse.destinationURL?.absoluteString)!)
                unzip(filePath: DefaultDownloadResponse.destinationURL! , onUnZip: onFinished)
            })
    }
    
    public static func unzip(filePath:URL , onUnZip: @escaping ()->Void){
        do{
            let sourceURL = filePath
            let fileManager = FileManager()
            //Create a directory from the zip file name
            let destinationURL = sourceURL.deletingLastPathComponent().appendingPathComponent(filePath.deletingPathExtension().lastPathComponent)

            try Zip.unzipFile(filePath, destination: destinationURL, overwrite: true, password: "", progress: { (progress) -> () in
                print("Unzip progress: " + String(progress * 100))
                if(progress >= 1){
                    onUnZip()
                }
            })
        } catch{
            print("Extraction of ZIP archive failed with error:\(error)")
        }
    }
    

}
