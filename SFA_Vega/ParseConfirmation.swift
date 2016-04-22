//
//  ParseConfirmation.swift
//  Vega3
//
//  Created by Владимир Невинный on 22.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation
import UIKit


class ParseConfirmation: NSObject, NSXMLParserDelegate {
    
    var orders: Bool
    var inventory: Bool
    var salesForBonus: Bool
    
    
    override init() {
        orders = false
        inventory   = false
        salesForBonus = false
        
        super.init()
    }
    
    convenience init(urlPath: NSURL) {
        self.init()
        
        let xml = NSXMLParser(contentsOfURL: urlPath)
        
        xml?.delegate = self
        
        if xml?.parse() == true {
            
            print("Was able to parse")
            
        }
    }
    
   
    
    
   /* convenience init(urlFTP: String) {
        self.init()
        
        let ftpURL = CFURLCreateWithString(nil, urlFTP, nil)
        
        let stream = CFReadStreamCreateWithFTPURL(nil, ftpURL)
        
        let streamRead: CFReadStream = stream.takeUnretainedValue()
        
        let cfstatus: Bool = CFReadStreamOpen(streamRead)
        if cfstatus == true {
       
            var buffer:[UInt8]  =  [UInt8](count: 5000000, repeatedValue: 0)
            var currentIndex = 0
            var index = 0
            
            repeat {
                index = CFReadStreamRead(streamRead, &(buffer[currentIndex]), 5000000)
                currentIndex += index
            }while index > 0
                
            let data = NSData(bytes: &buffer, length: 500000)
            let xml = NSXMLParser(data: data)
            
            xml.delegate = self
            
            if xml.parse() == true {
                print("Was able to parse")
            }
     
            CFReadStreamClose(streamRead)
            
        }
        
    }*/
    
    convenience init(urlFTP: String) {
        self.init()
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        if let url = NSURL(string: urlFTP) {
            
            session.dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let data = data {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let xml = NSXMLParser(data: data)
                        
                        xml.delegate = self
                        
                        if xml.parse() == true {
                            
                            print("Was able to parse")
                            
                        }
                    })
                    
                    
                } else {
                    print("no data")
                }
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                }.resume()
            
        } else {
            print("Incorrect FTP url")
        }
    }
    
    

    
    
    
    
    
    
    
    //MARK: - parser XML
    
    func parserDidEndDocument(parser: NSXMLParser) {
        let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)!
        try! managedObjectContext.save()
    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("Error \(validationError.localizedDescription)")
    }
    
    
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        
        if elementName == "inventary" {
            inventory = true
        }
        
        if elementName == "orders" {
            orders = true
        }
        
        if elementName == "salesForBonus" {
            salesForBonus = true
        }
        
        
        
        if elementName == "element" {
            let id = attributeDict["id"]!
            let num_doc = attributeDict["num_doc"]!
            
            if inventory {
               NVPInventory.confirm(id.uppercaseString, numberDocIn1C: num_doc)
            } else if orders {
                NVPOrder.confirm(id.uppercaseString, numberDocIn1C: num_doc)
            } else if salesForBonus {
                NVPSalesForBonus.confirm(id.uppercaseString, numberDocIn1C: num_doc)
            }
        }
        
        
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        if elementName == "inventary" {
            inventory = false
        }
        
        if elementName == "orders" {
            orders = false
        }
        
        if elementName == "salesForBonus" {
            orders = false
        }
    }
    
    
    //MARK: - add new
    
    
}
