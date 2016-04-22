//
//  Parse.swift
//  FTPManager
//
//  Created by Nevinniy Vladimir on 18.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class Parse: NSObject, NSXMLParserDelegate {
    
    var product: Bool
    var store: Bool
    var client: Bool
    var residuesCategory: Bool
    var plan_visit: Bool

    
    override init() {
        product = false
        store   = false
        client  = false
        residuesCategory = false
        plan_visit = false
        
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
    
    convenience init(data: NSData) {
        self.init()
        
        let xml = NSXMLParser(data: data)
        
        xml.delegate = self
        
        if xml.parse() == true {
            
            print("Was able to parse")
            
        }
    }
    
    
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
    
    
    
   /* convenience init(urlFTP: String) {
        self.init()
        
        let ftpURL = CFURLCreateWithString(nil, urlFTP, nil)
        
        let stream = CFReadStreamCreateWithFTPURL(nil, ftpURL)
        
        // if let stream = CFReadStreamCreateWithFTPURL(nil, ftpURL) {
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
            
            
            //  }
            
            CFReadStreamClose(streamRead)
            
        }
        
    }*/
    
    
    
    
    
    
    
    
    //MARK: - parser XML
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("Error \(validationError.localizedDescription)")
    }
    
   
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        
        if elementName == "products" {
            product = true
        }
        
        if elementName == "clients" {
            client = true
        }
        
        if elementName == "outlets" {
            store = true
        }
        
        if elementName == "category" {
             residuesCategory = true
        }

        if elementName == "plan_visit" {
            plan_visit = true
        }
        
        if elementName == "element" {
            if product {
                self.addProduct(attributeDict)
            } else if store {
                self.addStore(attributeDict)
            } else if client {
                self.addClient(attributeDict)
            } else if residuesCategory {
                self.addResiduesCategory(attributeDict)
            } else if plan_visit {
               // self.planVisit(attributeDict)
            }
        }
        
        
        if elementName == "group" {
            if product {
                self.addGroup(attributeDict)
                print("add group")
            }
        }
        
        
        
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
                
        if elementName == "products" {
            product = false
        }
        
        if elementName == "clients" {
            client = false
        }
        
        if elementName == "outlets" {
            store = false
        }
        
        if elementName == "category" {
            residuesCategory = false
        }
        
        if elementName == "plan_visit" {
            plan_visit = false
        }
    }
    
    func planVisit(attributeDict: [String : String]) {
        
        
        let dateFormattter = NSDateFormatter()
        dateFormattter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        
    //    let id         = attributeDict["id"]!
        let idStore       = attributeDict["idStore"]!
        
        
        let dateStart  = dateFormattter.dateFromString(attributeDict["timewith"]!)!
        let dateEnd    = dateFormattter.dateFromString(attributeDict["timebefore"]!)!
        
        
        
        var latitude: Double = 0
        
        if let _latitude = Double(attributeDict["latitude"]!) {
            latitude = _latitude
        }
        
        var longitude: Double = 0
        
        if let _longitude = Double(attributeDict["longitude"]!) {
            longitude = _longitude
        }
        
        //  dispatch_async(dispatch_get_main_queue() , { () -> Void in
        NVPPlanVisits.insertPlanVisits(dateStart: dateStart, dateEnd: dateEnd, idStore: idStore, latitude: latitude, longitude: longitude)
        //    })
        
        
        
    }
    
    
    //MARK: - add new 
    
    func addProduct(attributeDict: [NSObject : AnyObject]) {
        
        
        
        let id         = attributeDict["id"]        as! String
        let name       = attributeDict["name"]      as! String
        let fullname   = attributeDict["fullname"]  as! String
        let code       = attributeDict["code"]      as! String
        
  //      let group      = attributeDict["group"]     as! String
        let idgroup    = attributeDict["idgroup"]   as! String
        let barcode    = attributeDict["barcode"]   as! String
        let artikle    = attributeDict["artikle"]   as! String
        let order      = attributeDict["order"]     as! String
        let numberPage = attributeDict["numberPage"] as! String
        
        let contractPrice      = attributeDict["contractPrice"] as! String
        let idEd      = attributeDict["ided"]     as! String
        let nds       = attributeDict["NDS"]     as! String
        
        
        
        //stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let price1    = (attributeDict["price1"] as! NSString).doubleValue
        let price2    = (attributeDict["price2"] as! NSString).doubleValue
        let price3    = (attributeDict["price3"] as! NSString).doubleValue
        let price4    = (attributeDict["price4"] as! NSString).doubleValue
        
        print(price1)
        
        //NSNumber(double: (quantity as NSString).doubleValue)
        // dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        NVPProduct.insertProduct(id: id, name: name, fullname: fullname, code: code, idGroup: idgroup, barcode: barcode, artikle: artikle, order: Int(order)!, numberPage: Int(numberPage)!, contractPrice: Int(contractPrice)!, idEd: idEd, nds: nds, price1: price1, price2: price2, price3: price3, price4: price4)
        // })
        
    }
    
    func addClient(attributeDict: [NSObject : AnyObject]) {
        
        let id         = attributeDict["id"]        as! String
        let name       = attributeDict["name"]      as! String
        let fullname   = attributeDict["namefull"]  as! String
        let code       = attributeDict["code"]      as! String
        
        let okpo      = attributeDict["okpo"]     as! String
        
      //  dispatch_async(dispatch_get_main_queue() , { () -> Void in
                NVPClient.insertStore(id: id, name: name,  fullname: fullname, code: code, okpo: okpo)
    //    })
        
        
        
    }
    
    func addResiduesCategory(attributeDict: [NSObject : AnyObject]) {
        
        let idProduct  = attributeDict["goods"]        as! String
        let quantity   = attributeDict["qty"]      as! String
        let category   = attributeDict["category"]  as! String
        
        
        let qty = NSNumber(double: (quantity as NSString).doubleValue)
        
      //  dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NVPResiduesCategory.insertResiduesCategory(idProduct: idProduct, quantity: qty, category: category)
     //   })
        
        
        
        
    }
    
    
    func addGroup(attributeDict: [NSObject : AnyObject]) {
        
        let id         = attributeDict["id"]        as! String
        let name       = attributeDict["name"]      as! String
        let fullname   = attributeDict["fullname"]  as! String
        let code       = attributeDict["code"]      as! String
        
        
        let idgroup    = attributeDict["idgroup"]   as! String
       
             
       // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NVPProductGroup.insertGroup(id: id, name: name, fullname: fullname, code: code, idGroup: idgroup)
       // })
    }
    
    
    
    
    
    
    func addStore(attributeDict: [NSObject : AnyObject]) {
        
        let id         = attributeDict["id"]        as! String
        let name       = attributeDict["name"]      as! String
        let code       = attributeDict["code"]      as! String
        let idClient   = attributeDict["idkontr"]   as! String
        let category   = attributeDict["category"]  as! String
        let adress     = attributeDict["adress"]    as! String
        let idRTP      = attributeDict["idrtp"]     as! String
        let oblast     = attributeDict["oblast"]    as! String
        let region     = attributeDict["region"]    as! String
        
        
    //    dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NVPStore.insertStore(id: id, name: name, code: code, idClient: idClient, category: category, adress: adress, idRTP: idRTP, oblast: oblast, region: region)
      //  })
    }
    
    
    
}
