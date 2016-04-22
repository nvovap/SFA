//
//  ParseInventory.swift
//  SFA_Vega
//
//  Created by Nevinniy Vladimir on 09.10.15.
//  Copyright © 2015 Nevinniy Vladimir. All rights reserved.
//

import Foundation


class ParseInventory: NSObject, NSXMLParserDelegate {
    
    var orders: Bool
    var inventory: Bool
    
    
    override init() {
        orders = false
        inventory   = false
        
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
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("Error \(validationError.localizedDescription)")
    }
    
    
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        
        
        
        
        if elementName == "element" {
            let id_doc = attributeDict["id"]!
            let date_doc = attributeDict["date"]!
            let num_doc = attributeDict["numberDocIn1C"]!
            
            
            var latitude: Double = 0
            
            if let _latitude = Double(attributeDict["latitude"]!) {
                latitude = _latitude
            }
            
            
            var longitude: Double = 0
            
            if let _longitude = Double(attributeDict["longitude"]!) {
                longitude = _longitude
            }
            
            let factResidue = Double(attributeDict["factResidue"]!)!
           
            let idClient = attributeDict["idClient"]!
            let idProduct = attributeDict["idProduct"]!
            
            var inventory = NVPInventory.getLastInventory(idStory: idClient, idInventory: id_doc)
            
            if inventory == nil {
                
                
                inventory = NVPInventory.insertInventory(story: NVPStore.getStore(id: idClient)!)
                
                
                if let inventory = inventory {
                    inventory.date = date_doc.dateFromString
                    inventory.numberDocIn1C = num_doc
                    
                    
                    inventory.latitude = latitude
                    inventory.longitude = longitude
                    inventory.sent = true
                    inventory.confirmation = true
                    
                    
                    
                    
                }
                
                
            }
            
            if let inventory = inventory {
                if  let sect = NVPSectionInvet.insertSectionInventory(product: NVPProduct.getProduct(id: idProduct)!, inventory: inventory) {
                    sect.factResidue = factResidue
                   
                }
                
               
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
    }
    
    
    //MARK: - add new
    
    
}