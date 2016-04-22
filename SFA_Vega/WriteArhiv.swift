
import UIKit

class WriteArhiv: NSObject {
    
    
    
    override init() {
        
        super.init()
    }
    
    convenience init(urlFTP: String) {
        self.init()
        
      
        let infos = NVPInfoStory.getInfos()
        
        if let infos = infos {
            
            var data: NSData? = nil
            
            do {
                data = try NSJSONSerialization.dataWithJSONObject(infos, options: NSJSONWritingOptions.PrettyPrinted)
                _  = writeFTP(urlFTP, data: data)
            } catch {
                
            }
            
            
           
        }
        
        
        
        
    }
    
    
   
    

    
    func writeFTP(urlFTP: String, data: NSData?) -> Bool {
        
        let ftpstring = CFURLCreateWithString(nil, urlFTP, nil)
        
        
        
        
        let stream = CFWriteStreamCreateWithFTPURL(nil, ftpstring)
        
        //let stream = NSURLSessionA
        
        let streamWrite: CFWriteStream = stream.takeUnretainedValue()
        
        
      
        let cfstatus: Bool = CFWriteStreamOpen(streamWrite)
        
        if cfstatus == true {
            if let buffer = data {
                
                
                
                //  var offset = 0
                
                
                var currentIndex = 0
                
                var index = 0
                
                let buf = UnsafePointer<UInt8>(buffer.bytes)
                
                
                while currentIndex < buffer.length {
                    
                    
                    index = CFWriteStreamWrite(streamWrite, buf+currentIndex,  buffer.length-currentIndex)
                    
                    if index == -1 {
                        CFWriteStreamClose(streamWrite)
                        
                        return false
                    }
                    
                    if index > 0 {
                        currentIndex += index
                    }
                }
            }
            
            CFWriteStreamClose(streamWrite)
            
            return true
            
        }
        
        return false
    }
    
}
