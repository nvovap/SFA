//
//  ProductsViewController.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 25.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class ProductsViewController: UITableViewController, UISearchBarDelegate {
    
    var products: [NVPProduct]? = NVPProduct.getProducts(nil)
    var selectProduct: NVPProduct?
    
    var currentOperation: NSOperation?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if let products = products {
            return products.count
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 

        
        if let products = products {
            
            let product = products[indexPath.row]
            
            cell.textLabel?.text = product.name
            cell.detailTextLabel?.text = "\(product.order)"
           
            
        }
        
        
      
        

        return cell
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
            
            
            let _currentArray = NVPProduct.getProducts(searchBar.text)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.products = _currentArray
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == "ss" {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if let products = self.products {
                self.selectProduct = products[indexPath.row]
            }
        }
    }


}
