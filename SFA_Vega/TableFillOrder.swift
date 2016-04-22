//
//  TableFillOrder.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 30.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class TableFillOrder: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    @IBOutlet weak var commentTextView: UITextView!
    
  //  var managedObjectContext: NSManagedObjectContext? = nil
    
    var order: NVPOrder? {
        didSet {
            if let order = order {
                let sort = NSSortDescriptor(key: "orderProduct", ascending: true)
                
                self.sectionOrder =  order.section!.sortedArrayUsingDescriptors([sort]) as? [NVPSectionOrder]
                
                //self.sectionOrder = order.section.allObjects as? [NVPSectionOrder]
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var payFormaSegment: UISegmentedControl!
    
    
    var sectionOrder: [NVPSectionOrder]?
    
    
    //MARK: - varable for "Total summa"
    var typePrice: Int = 1
    
    var totalSumma: Double {
        get {
            var summa: Double = 0
            if let sectionOrder = sectionOrder {
                for res in sectionOrder {
                    if let product = NVPProduct.getProduct(id: res.idProduct) {
                        if product.contractPrice.boolValue == true {
                             summa += res.quantity.doubleValue * res.price.doubleValue
                        } else {
                            if let price = product.valueForKey("price\(typePrice)")?.doubleValue {
                                summa += res.quantity.doubleValue * price
                            }
                        }
                        
                    }
                }
            }
            
            return summa
        }
    }
    //MARK:
    
    
    @IBAction func changePayForma(sender: UISegmentedControl) {
        order?.payForma2  =  sender.selectedSegmentIndex == 0 ? false : true
        
        print(order?.payForma2.boolValue)
    }
    
    
    @IBAction func changedTypePrice(sender: UISegmentedControl) {
        firstTextField?.resignFirstResponder()
     
        typePrice = sender.selectedSegmentIndex + 1
        self.tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var index = 0
        
        addButtonItem.enabled = true
        
        if let order = order {
            index = order.payForma2.boolValue ? 1 : 0
           
            if order.confirmation == true || order.sent == true {
                addButtonItem.enabled   = false
                payFormaSegment.hidden  = true
                buttonSave.title = "Выйти"
                //commentTextView
            }
        }
        
        
        payFormaSegment.selectedSegmentIndex = index
        
        if let order = self.order {
            self.commentTextView.text = order.comment
        }
    }
    
       

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if let sectionOrder = sectionOrder {
            count =  sectionOrder.count
        }
        
        return count+1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if let sectionOrder = sectionOrder {
        if indexPath.row < sectionOrder.count {
            let residue = sectionOrder[indexPath.row]
            
            if let product  = NVPProduct.getProduct(id: residue.idProduct) {
                
                if order?.free == true {
                    
                    if product.contractPrice == 1 {
                        let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! CellForOrderTableViewCellPrice
                        cell.price.text       = "\(residue.price.doubleValue)"
                        cell.name.text           = NVPProduct.getProduct(id: residue.idProduct)?.name
                        cell.quantity.text       = "\(residue.quantity.doubleValue)"
                        
                        if let order = order {
                            if order.confirmation == true  || order.sent == true {
                                cell.quantity.enabled = false
                                cell.price.enabled = false
                            }
                        }
                        
                        return cell
                    }

                    let cell = tableView.dequeueReusableCellWithIdentifier("Cell3", forIndexPath: indexPath) as! CellForOrderTableViewCell
                    
                    cell.name.text           = NVPProduct.getProduct(id: residue.idProduct)?.name
                    
                    cell.quantity.text       = "\(residue.quantity.doubleValue)"
                    
                    if let order = order {
                        if order.confirmation == true  || order.sent == true {
                           cell.quantity.enabled = false
                        }
                    }

                    
                    return cell
                }
                
                if product.contractPrice == 1 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! CellForOrderTableViewCellPrice
                    cell.price.text       = "\(residue.price.doubleValue)"
                    cell.name.text           = NVPProduct.getProduct(id: residue.idProduct)?.name
                    cell.quantity.text       = "\(residue.quantity.doubleValue)"
                    
                    if let order = order  {
                        if order.confirmation == true  || order.sent == true {
                            cell.quantity.enabled = false
                            cell.price.enabled = false
                        }
                    }
                    
                    return cell
                }
            
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CellForOrderTableViewCell
                //cell.name.text           = "\(NVPProduct.getProduct(id: residue.idProduct)?.order.intValue) \(NVPProduct.getProduct(id: residue.idProduct)?.name)"
                
                cell.name.text           = NVPProduct.getProduct(id: residue.idProduct)?.name
                
                cell.residue.text       = "\(residue.residue.doubleValue)"
                cell.quantity.text       = "\(residue.quantity.doubleValue)"
                
                if let order = order {
                    if order.confirmation == true || order.sent == true {
                        cell.quantity.enabled = false
                    }
                }
                
                return cell
            }
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as! CellTotalOrder
                cell.summa.text = "\(self.totalSumma)"
           
                return cell
            }
        }
        
        let  cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CellForOrderTableViewCell
        
        return cell
    }
    
 
    
    /* override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? CellForOrderTableViewCell {
            cell.quantity.becomeFirstResponder()
        }
        
        return nil
    }*/

    
    
    
    // MARK: - UITextFieldDelegate
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if let order = order {
            if order.confirmation.boolValue {
                return false
            }
        }
        
        return true
    }
    
    
    var firstTextField: UIView?
    
    func textViewDidBeginEditing(textView: UITextView){
        firstTextField = textView
    }

    func textViewDidEndEditing(textView: UITextView){
        order?.comment = commentTextView.text
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField)  {
        firstTextField = textField
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
         if textField.tag == 1 {
            if let cell = textField.superview?.superview as? CellForOrderTableViewCell {
                let indexPathSave =  self.tableView.indexPathForCell(cell)
            
                if let indexPath = indexPathSave {
                    if var quantity = Double(textField.text!) {
                    
                        let currentRow = self.sectionOrder![indexPath.row]
                    
                        if currentRow.residue.doubleValue != 0 && currentRow.residue.doubleValue < quantity {
                            quantity = currentRow.residue.doubleValue
                            textField.text = quantity.description
                        }
                    
                        currentRow.quantity = quantity
                    }
                }
            }
        }else if textField.tag == 2 {
            if let cell = textField.superview?.superview as? CellForOrderTableViewCellPrice {
                let indexPathSave =  self.tableView.indexPathForCell(cell)
                
                if let indexPath = indexPathSave {
                   // let price = (textField.text as NSString).doubleValue
                    
                    var text = textField.text!
                    text = text.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    
                    
                    
                    if let price =  NSNumberFormatter().numberFromString(text)?.doubleValue {
                        self.sectionOrder![indexPath.row].price = price
                    } else {
                        self.sectionOrder![indexPath.row].price = 0
                    }
                }
            }
         }else if textField.tag == 3 {
            if let cell = textField.superview?.superview as? CellForOrderTableViewCellPrice {
                
                firstTextField?.resignFirstResponder()
                
                let indexPathSave =  self.tableView.indexPathForCell(cell)
                
                if let indexPath = indexPathSave {
                    if let quantity = Double(textField.text!) {
                        self.sectionOrder![indexPath.row].quantity = quantity
                    } else {
                        self.sectionOrder![indexPath.row].quantity = 0
                    }
                    
                }
            }
        }
        
        
       self.tableView.reloadData()
        
        
        
    }



    
    @IBAction func selectProduct(segue: UIStoryboardSegue) {
        if let productView = segue.sourceViewController as? ProductsViewController {
            if let selectProduct = productView.selectProduct {
                if let newSection = NVPSectionOrder.insertSectionOrder(product: selectProduct, order: self.order!, residue: 0 , quantity: 1, price: 0) {
                        
                    sectionOrder?.append(newSection)
                        
                    if let sectionOrder = sectionOrder {
                        let indexPath = NSIndexPath(forItem: sectionOrder.count-1, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                            
                        let indexNewPath = NSIndexPath(forItem: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)
                            
                        self.tableView.scrollToRowAtIndexPath(indexNewPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                            
                        if selectProduct.contractPrice == 1 {
                            if let cell = self.tableView.cellForRowAtIndexPath(indexNewPath) as? CellForOrderTableViewCellPrice {
                                cell.quantity.becomeFirstResponder()
                            }
                                
                         } else {
                            if let cell = self.tableView.cellForRowAtIndexPath(indexNewPath) as? CellForOrderTableViewCell {
                                cell.quantity.becomeFirstResponder()
                            }
                                
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
        }
    }



    // MARK: - Navigation
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        firstTextField?.resignFirstResponder()
        
        if segue.identifier == "SaveOrder" {
            
            
            if let order = order {
                //order.comment = self.commentTextView.text
                
                let loc = GetLocation.shared
                
                if loc.update {
                    print("Ok location")
                } else {
                    print("Error location")
                }
                
                order.longitude = loc.longitude
                order.latitude  = loc.latitude
                order.horizontalAccuracy = loc.horizontalAccuracy
                
                if let sectionOrder = sectionOrder {
                    order.section = NSSet(array: sectionOrder)
                    
                 //   order.managedObjectContext?.save()
                    
                    
                }
                
            }
        }
    }
   
   

}
