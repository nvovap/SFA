//
//  TableFillResidue.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 26.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit


class TableFillResidue: UITableViewController, UITextFieldDelegate {

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
    
    
    var inventory: NVPInventory? {
        didSet {
            if let inventory = inventory {
                let sort = NSSortDescriptor(key: "order", ascending: true)
                
                self.sectionInventory =  inventory.section!.sortedArrayUsingDescriptors([sort]) as? [NVPSectionInvet]
                
            }
            
            
            self.tableView.reloadData()
            
        }
    }
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    var sectionInventory: [NVPSectionInvet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addButtonItem.enabled = true
        
        if let inventory = inventory  {
            if inventory.confirmation == true || inventory.sent == true {
                addButtonItem.enabled = false
            }
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func changedTypePrice(sender: UISegmentedControl) {        
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
        
        
        return count + 1

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if let sectionInventory = sectionInventory {
            if indexPath.row < sectionInventory.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellForInventoryTableViewCell
                let residue = sectionInventory[indexPath.row]
            
                cell.name.text          = residue.nameProduct
                cell.residue.text       = "\(residue.quantityCategory.doubleValue)"
                cell.factResidue.text   = "\(residue.factResidue.doubleValue)"
            
            
                if let inventory = inventory {
                    if inventory.confirmation == true || inventory.sent == true {
                        cell.factResidue.enabled = false
                    }
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! CellTotalOrder
                
                
                cell.summa.text = "\(self.totalSumma)"
                
                
                return cell
                
                
            }
        }
   
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellForInventoryTableViewCell
        return cell
    }
    
    
    
    
   
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? CellForInventoryTableViewCell {
            cell.factResidue.becomeFirstResponder()
        }
        
        return nil
    }

    // MARK: - UITextFieldDelegate
    
    var firstTextField: UITextField?
    
    func textFieldDidBeginEditing(textField: UITextField)  {
        firstTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let cellTest = textField.superview?.superview
        
        print(cellTest)
        
        if let cell = textField.superview?.superview as? CellForInventoryTableViewCell {
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
    
   
    
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //NewOrder

        firstTextField?.resignFirstResponder()

        if segue.identifier == "NewOrder" {
            
            let loc = GetLocation.shared
            
            
            if loc.update {
                print("Ok location")
            } else {
                print("Error location")
            }
            
            
            if let story = inventory?.story {
                if  let order = NVPOrder.insertOrder(store: story, free: false, payForma2: false) {
            
                    inventory?.longitude = loc.longitude
                    inventory?.latitude  = loc.latitude
                    inventory?.horizontalAccuracy = loc.horizontalAccuracy
                    
                    order.idInventory = inventory!.id
                    
                    loc.stopUpdatingLocation()
                   
                    
                    for section in self.sectionInventory! {
                                            
                        if section.quantityCategory.doubleValue == 0 {
                            continue
                        }
                        
                        
                        let quantity: Double = section.quantityCategory.doubleValue - section.factResidue.doubleValue
                        
                        if quantity>0 {
                            NVPSectionOrder.insertSectionOrder(product: NVPProduct.getProduct(id: section.idProduct)!, order: order, residue: quantity, quantity: 0, price: 0)
                        }
                        
                    }
                    
                    if let sectionInventory = sectionInventory {
                        inventory!.section = NSSet(array: sectionInventory)
                    }
            
                    do {
                        try inventory?.managedObjectContext?.save()
                    } catch {
                        fatalError("Fetching from the store failed")
                    }
                   
                    
                    
                    
                    
                    (segue.destinationViewController as! TableFillOrder).order = order
                }
 
            }
        } else if segue.identifier == "SelectPhotoSegue" {
            
            if let inventory = self.inventory  {
                
                (segue.destinationViewController as! PhotosViewController).inventory = inventory
            }
            
        }
        
        
    }
    
    @IBAction func selectProduct(segue: UIStoryboardSegue) {
        if let productView = segue.sourceViewController as? ProductsViewController {
            
           // firstTextField?.resignFirstResponder()
            
            //if let inventory = inventory {
                
                if let newSection = NVPSectionInvet.insertSectionInventory(product: productView.selectProduct!, inventory: self.inventory!) {
                    
                    sectionInventory?.append(newSection)
                    
                    if let sectionInventory = sectionInventory {
                    
                        let indexPath = NSIndexPath(forItem: sectionInventory.count-1, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                        let indexNewPath = NSIndexPath(forItem: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)
                        
                        self.tableView.scrollToRowAtIndexPath(indexNewPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    
                        if let cell = self.tableView.cellForRowAtIndexPath(indexNewPath) as? CellForInventoryTableViewCell {
                            cell.factResidue.becomeFirstResponder()
                        }
                    }
                    
                    
                }
                
            self.tableView.reloadData()
        }
    }

}
