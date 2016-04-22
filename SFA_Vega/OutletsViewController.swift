//
//  OutletsViewController.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 25.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class OutletsViewController: UITableViewController {

   /* var categore: NVPCategory? {
        didSet {
            // Update the view.
            self.tableView.reloadData()
        }

    }*/
    
    var clients: [NVPClient]?  = NVPClient.getClients(nil)
    
    var currentOperation: NSOperation?
    
    var noRessidue: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        var count = 0
        
        if let clients = clients {
            count = clients.count
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        
        if let clients = clients {
            title = clients[section].name
        }
        
        
        
        return title
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if let outlets = categore?.stores.count {
            return outlets
        }*/
        
        var count = 0
        
        if let clients = clients {
            count = clients[section].outlets.count
        }
        
        
        return count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellName = noRessidue ? "Cell2" : "Cell"
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) 

        if let clients = clients {
            if let store = clients[indexPath.section].outlets.allObjects[indexPath.row]  as? NVPStore {
                
               
                
                let text =  store.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
               
                var categoryText =  NSMutableAttributedString(string: "")
               
                
                switch store.category!.name {
                case "А":
                    categoryText =  NSMutableAttributedString(string: "A "+text)
                    categoryText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 1))
                    
                case "В":
                    categoryText =  NSMutableAttributedString(string: "B "+text)
                    categoryText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSMakeRange(0, 1))
                   
                case "С":
                    categoryText =  NSMutableAttributedString(string: "C "+text)
                    categoryText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(0, 1))
                    
                    
                default:
                    categoryText =  NSMutableAttributedString(string: text)
                    print(store.category!.name)
                    break
                }
                
                //let color = object.payForma2.boolValue ? UIColor.redColor() : UIColor.blueColor()
                
                
                
                
                
                
                cell.textLabel?.attributedText =  categoryText
                
                cell.detailTextLabel?.text =  store.adress.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        }
       
        
        /*if let clients = clients {
            if let store = clients[indexPath.section].outlets.allObjects[indexPath.row]  as? NVPStore {
                cell.textLabel?.text = store.name
                cell.detailTextLabel?.text =  store.adress
                
                var nameImage = "detail"
                
                if store.info == nil {
                    nameImage = "add"
                }
                
                let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 24))
                
                let infoButton1 = UIButton(frame: CGRect(x: 5, y: 0, width: 24, height: 24))
                infoButton1.backgroundColor = UIColor.clearColor()
                infoButton1.setImage(UIImage(named: nameImage), forState: UIControlState.Normal)
                infoButton1.addTarget(self, action: Selector("testButton:forEvent:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                
                let disclosure = UIImageView(frame: CGRect(x: 35, y: 0, width: 24, height: 24))
                disclosure.image = UIImage(named: "disclosure")
                
                
                
                
                infoView.addSubview(infoButton1)
                infoView.addSubview(disclosure)
                
                cell.accessoryView = infoView
                
            }
        }*/

        return cell
    }
    
    func testButton(sender: UIButton, forEvent event: UIEvent) {
       let touches = event.allTouches()
        if let touch = touches!.first  {
        
            let point = touch.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(point) {
                if let clients = clients {
                    let sortOblast  = NSSortDescriptor(key: "oblast", ascending: true)
                    let sortRegion  = NSSortDescriptor(key: "region", ascending: true)
                    let sortName    = NSSortDescriptor(key: "name", ascending: true)
                    if let store    = clients[indexPath.section].outlets.sortedArrayUsingDescriptors([sortOblast, sortRegion,sortName])[indexPath.row]  as? NVPStore {
                        
                        self.performSegueWithIdentifier("showInfo", sender: store)
                }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath){
        if let clients = clients {
            let sortOblast  = NSSortDescriptor(key: "oblast", ascending: true)
            let sortRegion  = NSSortDescriptor(key: "region", ascending: true)
            let sortName    = NSSortDescriptor(key: "name", ascending: true)
            if let store    = clients[indexPath.section].outlets.sortedArrayUsingDescriptors([sortOblast, sortRegion,sortName])[indexPath.row]  as? NVPStore {
                self.performSegueWithIdentifier("showInfo", sender: store)
            }
        }
    }
    
    
    //MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if currentOperation != nil {
            currentOperation!.cancel()
        }
        
        currentOperation = NSBlockOperation(block: { () -> Void in
            
            
            let _currentArray =  NVPClient.getClients(searchBar.text)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.clients = _currentArray
                self.tableView.reloadData()
                
                self.currentOperation = nil
            })
            
            
        })
        
        currentOperation?.start()
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    @IBAction func saveInfo(segue: UIStoryboardSegue){
        let vc = (segue.sourceViewController as! InfoForStoryViewController)
        
        if vc.story?.info == nil {
            vc.story?.info = NVPInfoStory.insertInfo(store: vc.story!, info: vc.textInfo.text)!
        } else {
            vc.story?.info?.info = vc.textInfo.text
        }
        
        
        
        do {
            try vc.story?.managedObjectContext?.save()
        } catch {
             fatalError("Save error")
        }
        
        //self.tableView.reloadData()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == "showInfo" {
            return false
        }
        
        return true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SelectSalesForBonuseSegue" {
        
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let clients = clients {
                    if let store = clients[indexPath.section].outlets.allObjects[indexPath.row]  as? NVPStore {
                        
                        if let sales  = NVPSalesForBonus.insertSales(store: store){
                            (segue.destinationViewController as! SalesForBonuseDocument).sales = sales
                        }
                    }
                }
            }
        
        } else if segue.identifier == "showInfo" {
            
            if let store = sender as? NVPStore {
                
                (segue.destinationViewController as! InfoForStoryViewController).story = store
            }
            
        } else if segue.identifier == "SelectStoreSegue" || segue.identifier == "SelectStoreSegue2" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let clients = clients {
                    let loc = GetLocation.shared
                    
                    loc.startUpdatingLocation()
                    
                    if let store = clients[indexPath.section].outlets.allObjects[indexPath.row]  as? NVPStore {
                       
                        if let alertLocation = loc.alert {
                            self.presentViewController(alertLocation, animated: true, completion: nil)
                            
                            return
                        }
                        
                        if noRessidue == true {
                            
                            if let order = NVPOrder.insertOrder(store: store, free: true, payForma2: false){
                                (segue.destinationViewController as! TableFillOrder).order = order
                            }
                            
                        } else if let inventory = NVPInventory.insertInventory(story: store){
                            
                            if let residues = store.category!.residues {
                                for residue in residues.allObjects {
                                    NVPSectionInvet.insertSectionInventory(residuesCategory: residue as! NVPResiduesCategory, inventory: inventory)
                                }                                
                            }
                            
                            
                            (segue.destinationViewController as! TableFillResidue).inventory = inventory
                            
                        }
                        
                        
                    }
                }
                
            }
        }
        
    }
    

}
