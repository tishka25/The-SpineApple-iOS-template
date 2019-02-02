//
//  LocalServer.swift
//  The SpineApp
//
//  Class with static funcions for starting and stopping a local server,
//  and downloading source code
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
    
    
    public static func sendUUID(){
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        let _id:String = deviceId!.sha1().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print("Hashed UUID is: ", _id)
        //TODO uncomment for production
        //Change the URL
//        let getRequest = URL(string: "http://localhost:6969/api/" + _id)
//        Alamofire.request(URLRequest(url:getRequest!)).responseString{ response in
//            print(response)
//        }
        
    }
    
    //Setup the server with the directory that is going to be shared
    public static func initServer(path:String = LocalServer.getDocumentsDirectory().appendingPathComponent("thespineapple").path){
        
        server = demoServer(path)
        server["/:path"] = shareFilesFromDirectory(path)
        
        
    }
    //Start the server with default port 8080
    public static func startServer(){
        try! server.start(8080)
        print("Server has started on " + (offlineURL?.absoluteString)!);
    }
    //Stop the server to save battery
    public static func stopServer(){
        server.stop()
    }
    
    //Helper function for getting the Documents directory
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    //Download ZIP and unzip the file from SpineApple server
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
    
    //Unzip helper function
    public static func unzip(filePath:URL , onUnZip: @escaping ()->Void){
        do{
            let sourceURL = filePath
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




//Extension for String , to add HASH functionalities
extension Data {
    
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    var sha1: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA1($0, CC_LONG(self.count), &digest)
        })
        return Data(bytes: digest)
    }
    
}

extension String {
    
    var hexString: String {
        return self.data(using: .utf8)!.hexString
    }
    
    var sha1: Data {
        return self.data(using: .utf8)!.sha1
    }
    
}
