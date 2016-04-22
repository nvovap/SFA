//
//  SettingsVC.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 24.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

let usersSetings = ["test":"test"]




class SettingsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var buttonSendMassage: UIButton!
    
    @IBOutlet weak var buttonGetMessage: UIButton!
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var labelUser: UILabel!
    
    @IBOutlet weak var userText: UITextField!
    
    @IBOutlet weak var saveUserButton: UIButton!
    
    @IBOutlet weak var layoutLabelUser: NSLayoutConstraint!
    
    @IBOutlet weak var layoutUserText: NSLayoutConstraint!

    @IBOutlet weak var layoutSaveUserButton: NSLayoutConstraint!
    
 
//    @IBAction func sendFileFTP() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        if let linkName = defaults.stringForKey("link") {
//            if let user = defaults.stringForKey("user") {
//                if let password = defaults.stringForKey("password") {
//                    let link = "ftp://\(user):\(password)@\(linkName)/"
//                    
//                    
//                    let photo = NSBundle.mainBundle().pathForResource("1", ofType: "mp3")!
//                    
//                    
//                      //      let linkFTP = link+"23.mp3"
//                            
//                      //      _ = WriteFTP(urlFTP: linkFTP, pathImage: photo)
//                    
//                    
//                    
//                }
//            }
//        }
//    }
  
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

   
    func keyboardWillShowNotification(notification: NSNotification) {
        if let info = notification.userInfo {
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            self.layoutLabelUser.constant = 27 + keyboardFrame.height
            self.layoutUserText.constant  = 22 + keyboardFrame.height
            self.layoutSaveUserButton.constant = 23 + keyboardFrame.height
            
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        self.layoutLabelUser.constant = 27
        self.layoutUserText.constant  = 22
        self.layoutSaveUserButton.constant = 23
    }
    
    @IBAction func onGetInv() {
        
        buttonSendMassage.enabled = false
        buttonGetMessage.enabled = false
        spinner.startAnimating()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let linkName = defaults.stringForKey("link") {
            if let user = defaults.stringForKey("user") {
                if let password = defaults.stringForKey("password") {
                    
                    let link = "ftp://\(user):\(password)@\(linkName)/Inventory.xml"
                    
                    _ = ParseInventory(urlFTP: link)
                    
                    
                    /*  if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
                    do {
                    try managedObjectContext.save()
                    } catch {
                    fatalError("Fetching from the store failed")
                    }
                    }*/
                }
            }
        }
        
        
        // dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.buttonSendMassage.enabled = true
        self.buttonGetMessage.enabled = true
        self.spinner.stopAnimating()
        // })
        // })
        
    }
    
    
    @IBAction func onGetData(sender: AnyObject) {
        buttonSendMassage.enabled = false
        buttonGetMessage.enabled = false
        spinner.startAnimating()
        
        let defaults = NSUserDefaults.standardUserDefaults()
                
        if let linkName = defaults.stringForKey("link") {
            if let user = defaults.stringForKey("user") {
                if let password = defaults.stringForKey("password") {
        
                  //  let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                //dispatch_async(queue, { () -> Void in
                //let user = "am8"
                 //let password = "dAC3biXQ3bqAUMJQ"
                //let link = "ftp://\(user):\(password)@ftp.mlife.dp.ua/data.xml"
                
                    var link = "ftp://\(user):\(password)@\(linkName)/confirmation.xml"
                    
                    _ = ParseConfirmation(urlFTP: link)
                    
                    
                    link = "ftp://\(user):\(password)@\(linkName)/data.xml"
            
                    _ = Parse(urlFTP: link)
            
            
                  /*  if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
                        do {
                            try managedObjectContext.save()
                        } catch {
                            fatalError("Fetching from the store failed")
                        }
                    }*/
                }
            }
        }
        
        
           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.buttonSendMassage.enabled = true
                self.buttonGetMessage.enabled = true
                self.spinner.stopAnimating()
           // })
       // })
        
        
    }
    
    
    

    @IBAction func sendMassage(sender: AnyObject) {
        
        buttonSendMassage.enabled = false
        buttonGetMessage.enabled = false
        spinner.startAnimating()
        
      //  let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        //dispatch_async(queue) { () -> Void in
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let linkName = defaults.stringForKey("link") {
            if let user = defaults.stringForKey("user") {
                if let password = defaults.stringForKey("password") {
        /*let user = "am8"
        let password = "3LTupDF6xM8V"
        var link = "ftp://\(user):\(password)@ftp.mlife.dp.ua/confirmation.xml"*/
         
                    let link = "ftp://\(user):\(password)@\(linkName)/confirmation.xml"
                    
                    _ = ParseConfirmation(urlFTP: link)
        
                   // link = "ftp://\(user):\(password)@\(linkName)/docs.xml"
                    
                    _ = WriteXML(url: linkName, user: user, password: password)

                    
            
            
        
                }
            }
        }
        
            if let managedObjectContext = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext) {
                do {
                    try managedObjectContext.save()
                } catch {
                    fatalError("Fetching from the store failed")
                }
                
                
            }
        
            
            
           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.buttonSendMassage.enabled = true
                self.buttonGetMessage.enabled = true
                self.spinner.stopAnimating()
           // })
      //  }
        
        
        
        
        
        //inventores.last?.managedObjectContext?.save(nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first  {
            let numTabs = touch.tapCount
            let numTouches = event!.allTouches()?.count
            
            
            if numTouches == 2 && numTabs == 3{
                labelUser.hidden = false
                userText.hidden = false
                saveUserButton.hidden = false
                
            }
            
        }

    }
    
    
    
    
    @IBAction func saveUser() {
        labelUser.hidden = true
        userText.hidden  = true
        saveUserButton.hidden = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let linkName = "ftp.mlife.dp.ua"
        let user = userText.text!
        if let password = usersSetings[user] {
            defaults.setObject(linkName, forKey: "link")
            defaults.setObject(user, forKey: "user")
            defaults.setObject(password, forKey: "password")
        }
        
        userText.resignFirstResponder()
        
        
        
        
    }
    
    
  
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
