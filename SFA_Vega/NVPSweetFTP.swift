//
//  NVPSweetFTP.swift
//  SweetFTP
//
//  Created by nvovap on 12/17/15.
//  Copyright © 2015 nvovap. All rights reserved.
//

import Foundation


class NVPSweetFTP: NSObject {
    private var session: NSURLSession!
    private var writeStream: NSURLSessionStreamTask!
    var error = false
    var errorMessage: String = ""
    
    
    var user: String
    var password: String
    var link: String
    
    
    init(link: String, user: String, password: String ) {
        self.link = link
        self.user = user
        self.password = password
        
        super.init()
    }
    
    
    
    private func isError(ready:()->()){
        self.writeStream.readDataOfMinLength(10, maxLength: 65536, timeout: 60, completionHandler: { (data, complit, error) -> Void in
            
            self.error = true
            
            if let data = data {
                
                if let convertString = String(data: data, encoding: NSUTF8StringEncoding) {
                    
                    if let chError = convertString.characters.first {
                       
                        
                        if chError != "4" && chError != "5"  {
                            self.error = false
                        }
                    }
                }
            }
            
            
            if self.error {
                self.disconnect()
            }
            
            ready()
            
        })
        
        self.writeStream.resume()
    }
    
    
    private func sentFTP(command: String, ready:()->()) {
        
        
        
        let data: NSData = String(command+"\r\n").dataUsingEncoding(NSASCIIStringEncoding)!
      
        self.writeStream.writeData(data, timeout: 60) { (error) -> Void in
            self.isError(ready)
        }
        writeStream.resume()
    }
    
    func disconnect() {
        if self.error != true  {
            self.sentFTP("QUIT", ready: { () -> () in
                
            })
        }
        
        self.writeStream.closeWrite()
        self.writeStream.closeRead()
    }

    func connect(compiled: (error: Bool, errorMessage: String)->()) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.allowsCellularAccess = true
        configuration.HTTPMaximumConnectionsPerHost = 1
        
        session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        
        writeStream = session.streamTaskWithHostName(self.link, port: 21)
        
        self.errorMessage = ""
        self.error = false
        
        self.isError { () -> () in
            if self.error == true {
                self.errorMessage = "no connect to internet"
                
                
                compiled(error: self.error, errorMessage: self.errorMessage)
                
                return
            }
            
            
            self.sentFTP("USER "+self.user, ready: { () -> () in
                
                self.sentFTP("PASS "+self.password, ready: { () -> () in
                    
                    if self.error == true {
                        self.errorMessage = "incorect password"
                        self.disconnect()
                    }
                    
                    compiled(error: self.error, errorMessage: self.errorMessage)
                })
            })
        }
    }
    
    
    
    
    func makeDirecrory(name: String, compiled: (error: Bool, errorMessage: String)->()) {
        
        self.errorMessage = ""
        self.error = false
        
        self.sentFTP("MKD "+name, ready: { () -> () in
            if self.error == true {
                self.errorMessage = "incorect name directory"
            }
            compiled(error: self.error, errorMessage: self.errorMessage)
        })
       
    }
}

