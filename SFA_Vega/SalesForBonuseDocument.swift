import UIKit

class SalesForBonuseDocument: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    

    var sales: NVPSalesForBonus? {
        didSet {
            if let sales = sales {

                
                self.sectionSales =  sales.section!.allObjects as? [NVPSectionSalesForBonus]
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    

    
    var sectionSales: [NVPSectionSalesForBonus]?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addButtonItem.enabled = true
        
        if let sales = sales {
            
            if sales.confirmation == true || sales.sent == true {
                addButtonItem.enabled   = false
                buttonSave.title = "Выйти"
            }
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if let sectionSales = sectionSales {
            count =  sectionSales.count
        }
        
        return count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellForSalesTableViewCell
        
        
        if let sectionSales = sectionSales {
            
            let salesOne = sectionSales[indexPath.row]
            
            if let product  = NVPProduct.getProduct(id: salesOne.idProduct) {
                
                cell.name.text           = product.name
                
                cell.quantity.text       = "\(salesOne.quantity.doubleValue)"
                
                if let sales = self.sales {
                    if sales.confirmation == true  || sales.sent == true {
                        cell.quantity.enabled = false
                    }
                }
            }
        }
        
        
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
        
        if let sales = sales {
            if sales.confirmation.boolValue {
                return false
            }
        }
        
        return true
    }
    
    
    var firstTextField: UIView?
    
    func textViewDidBeginEditing(textView: UITextView){
        firstTextField = textView
    }
    
  
    
    
    func textFieldDidBeginEditing(textField: UITextField)  {
        firstTextField = textField
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if let cell = textField.superview?.superview as? CellForSalesTableViewCell {
            
            firstTextField?.resignFirstResponder()
            
            let indexPathSave =  self.tableView.indexPathForCell(cell)
            
            if let indexPath = indexPathSave {
                if let quantity = Double(textField.text!) {
                    self.sectionSales![indexPath.row].quantity = quantity
                } else {
                    self.sectionSales![indexPath.row].quantity = 0
                }
                
            }
        }
        
        self.tableView.reloadData()
        
   }
    
    
    
    
    @IBAction func selectProduct(segue: UIStoryboardSegue) {
        if let productView = segue.sourceViewController as? ProductsViewController {
            if let selectProduct = productView.selectProduct {
                if let newSection = NVPSectionSalesForBonus.insertSectionSalesForBonus(product: selectProduct, salesForBonus: self.sales!, quantity: 1) {
                    
                    sectionSales?.append(newSection)
                    
                
                    
                    if let sectionSales = sectionSales {
                   
                        let indexPath = NSIndexPath(forItem: sectionSales.count-1, inSection: 0)
                        
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                        let indexNewPath = NSIndexPath(forItem: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)
                        
                        self.tableView.scrollToRowAtIndexPath(indexNewPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                        
                        if let cell = self.tableView.cellForRowAtIndexPath(indexNewPath) as? CellForSalesTableViewCell {
                            cell.quantity.becomeFirstResponder()
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
        
        if segue.identifier == "SaveSales" {
            if let sales = sales {
                if let sectionSales = sectionSales {
                    sales.section = NSSet(array: sectionSales)
                }
            }
        }
    }
    
    
    
}
