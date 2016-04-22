//
//  EditTableResidue.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 13.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class EditTableResidue: UITableViewController {

    var inventory: NVPInventory? {
        didSet {
            if let inventory = inventory {
                let sort = NSSortDescriptor(key: "order", ascending: true)
                
                self.sectionInventory =  inventory.section!.sortedArrayUsingDescriptors([sort]) as? [NVPSectionInvet]
                
            }
            
            
            self.tableView.reloadData()
            
        }
    }
    
    
    //MARK: - varable for "Total summa"
    var typePrice: Int = 1
    
    var totalSumma: Double {
        get {
            var summa: Double = 0
            if let sectionInventory = sectionInventory {
                for res in sectionInventory {
                    if let product = NVPProduct.getProduct(id: res.idProduct) {
                        if let price = product.valueForKey("price\(typePrice)")?.doubleValue {
                            summa += res.factResidue.doubleValue * price
                        }
                    }
                }
            }
            
            return summa
        }
    }
    //MARK:
    
    var sectionInventory: [NVPSectionInvet]?
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let inventory = inventory  {
            if inventory.confirmation == true || inventory.sent == true {
                addButtonItem.enabled = false
            }
        }

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changedTypePrice(sender: UISegmentedControl) {
        firstTextField?.resignFirstResponder()
        
        typePrice = sender.selectedSegmentIndex + 1
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let sectionInventory = sectionInventory {
            count =  sectionInventory.count
        }
        
        
        return count+1

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if let sectionInventory = sectionInventory {
            if indexPath.row < sectionInventory.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellForOrderTableViewCell
                
                let residue = sectionInventory[indexPath.row]
            
                cell.name.text          = residue.nameProduct
                cell.quantity.text       = "\(residue.factResidue.doubleValue)"
                // cell.factResidue.text   = "\(residue.factResidue.doubleValue)"
            
            
                if let inventory = inventory {
                    //print(inventory.confirmation)
                    if inventory.confirmation == true || inventory.sent == true {
                        cell.quantity.enabled = false
                    }
                }
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! CellTotalOrder
                
                
                cell.summa.text = "\(self.totalSumma)"
                
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellForOrderTableViewCell
        return cell
        
    }
    

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? CellForOrderTableViewCell {
            cell.quantity.becomeFirstResponder()
        }
        
        return nil
    }
    
    // MARK: - UITextFieldDelegate
    
    var firstTextField: UITextField?
    
    func textFieldDidBeginEditing(textField: UITextField)  {
        firstTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if let cell = textField.superview?.superview as? CellForOrderTableViewCell {
            let indexPathSave =  self.tableView.indexPathForCell(cell)
            
            if let indexPath = indexPathSave {
                if let factResidue = Double(textField.text!) {
                    self.sectionInventory![indexPath.row].factResidue = factResidue
                } else {
                    self.sectionInventory![indexPath.row].factResidue = 0
                }
            }
        }
        
        self.tableView.reloadData()
        

    }
    
 
    
    @IBAction func selectProduct(segue: UIStoryboardSegue) {
        if let productView = segue.sourceViewController as? ProductsViewController {
            if let newSection = NVPSectionInvet.insertSectionInventory(product: productView.selectProduct!, inventory: self.inventory!) {
                sectionInventory?.append(newSection)
                if let sectionInventory = sectionInventory {
                    let indexPath = NSIndexPath(forItem: sectionInventory.count-1, inSection: 0)
                    
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    let indexNewPath = NSIndexPath(forItem: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)
                    
                    self.tableView.scrollToRowAtIndexPath(indexNewPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    if  let cell = self.tableView.cellForRowAtIndexPath(indexNewPath) as? CellForOrderTableViewCell  {
                        cell.quantity.becomeFirstResponder()
                    }               
                }
            }
            
            self.tableView.reloadData()
        }
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        firstTextField?.resignFirstResponder()
        
        if segue.identifier == "SaveInventory" {
            do {
                try sectionInventory?.last?.managedObjectContext?.save()
            } catch {
                fatalError("No save Inventory in Table Residue")
            }
            
        } else if segue.identifier == "SelectPhotoSegue2" {
            
            if let inventory = self.inventory  {
                
                (segue.destinationViewController as! PhotosViewController).inventory = inventory
            }
            
        }
    }
    
}
