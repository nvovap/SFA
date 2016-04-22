//
//  WriteFTP.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 29.08.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import Photos


class WriteFTP {
    
    private var sweetFTP: NVPSweetFTP!
    
    init(url: String, user: String, password: String, inventory: NVPInventory){
        
        let newURl =  "ftp://"+user+":"+password+"@"+url+"/"
        
        sweetFTP = NVPSweetFTP(link: url, user: user, password: password)
        
        writeFTP(newURl, inventory: inventory)
    }
    
    func writeFTP(urlFTP: String, inventory: NVPInventory) -> Bool {
        
        
        
        
        let manager = PHImageManager.defaultManager()
        
        
        
        if let photos = NVPVisitPhotos.getPhotos(inventory: inventory, sendToFTP: true) {
            
            var indentifiers = [String]()
            
            
            for  photoVisit: NVPVisitPhotos in photos {
                indentifiers.append(photoVisit.photo)
            }
            
            
            //Создаем каталог
            if photos.count > 0 {
                
                sweetFTP.connect({ (error, errorMessage) -> () in
                    
                    if error == true {
                        print(errorMessage)
                        return
                    }
                    
                    self.sweetFTP.makeDirecrory(inventory.id, compiled: { (error, errorMessage) -> () in
                        if error == true {
                            print(errorMessage)
                        }
                        
                        self.sweetFTP.disconnect()
                        
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.predicate = NSPredicate(format: "localIdentifier IN %@", indentifiers)
                        let assetResults = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
                        
                        
                        
                        
                        var numberFile = 0
                        
                        for  photoVisit: NVPVisitPhotos in photos {
                            photoVisit.sent = true
                        }
                        
                        assetResults.enumerateObjectsUsingBlock { (object, count, stop) -> Void in
                            if let asset = object as? PHAsset {
                                
                                let options = PHImageRequestOptions()
                                options.synchronous = true
                                
                                
                                
                                manager.requestImageDataForAsset(asset, options: nil, resultHandler: { (data, hz, UIImageOrientationUp, info ) -> Void in
                                    if let _data = data {
                                        
                                        
                                      //  let path = NSBundle.mainBundle().pathForResource("1", ofType: "JPG")!
                                        
                                        
                 
                                         let data = NSData(data: _data)
                                            
                                            
                                        
                                        numberFile++
                                        
                                        let pathToSave = urlFTP+"\(inventory.id)/\(numberFile).jpg"
                                        print(pathToSave)
                                        
                                        
                                        let buf     = (UnsafePointer<UInt8>(data.bytes))
                                        let buf2    = (UnsafePointer<Void>(data.bytes))
                                        let buf3    = (UnsafeMutablePointer<Void>(data.bytes))
                                        //println(data.length)
                                        
                                        
                                        var leftOverSize        = data.length
                                        let bytesFile           = data.length
                                        var totalBytesWritten   = 0
                                        var bytesWritten        = 0
                                        
                                        
                                        
                                        let ftpstring = CFURLCreateWithString(nil, pathToSave, nil)
                                        
                                        let stream = CFWriteStreamCreateWithFTPURL(nil, ftpstring)
                                        let streamWrite: CFWriteStream = stream.takeUnretainedValue()
                                        
                                        
                                        let cfstatus: Bool = CFWriteStreamOpen(streamWrite) as Bool
                                        
                                        if cfstatus == true {
                                            repeat{
                                                // Write the data to the write stream
                                                bytesWritten = CFWriteStreamWrite(streamWrite, buf, leftOverSize)
                                                print("bytesWritten: \(bytesWritten)")
                                                if (bytesWritten > 0) {
                                                    totalBytesWritten += bytesWritten
                                                    // Store leftover data until kCFStreamEventCanAcceptBytes event occurs again
                                                    if (bytesWritten < bytesFile) {
                                                        leftOverSize = bytesFile - totalBytesWritten
                                                        memmove(buf3, buf2 + bytesWritten, leftOverSize)
                                                    }else{
                                                        leftOverSize = 0
                                                    }
                                                    
                                                }else{
                                                    print("CFWriteStreamWrite returned \(bytesWritten)")
                                                    break
                                                }
                                                
                                                if CFWriteStreamCanAcceptBytes(streamWrite) == false {
                                                    sleep(1)
                                                }
                                            }while((totalBytesWritten < bytesFile))
                                            
                                            print("totalBytesWritten: \(totalBytesWritten)")
                                            
                                            CFWriteStreamClose(streamWrite)
                                            
                                            
                                        }
                                    }
                                        
                                    
                                    
                                })
                            }
                        }
                    })
                })
            }
        }
        
        
        try! inventory.managedObjectContext?.save()
       
        
        
        return false
    }
    
    
}
