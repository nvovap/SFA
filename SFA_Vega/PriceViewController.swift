//
//  PriceViewController.swift
//  SFA_Vega
//
//  Created by Nevinniy Vladimir on 14.09.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class PriceViewController: UITableViewController, UISearchBarDelegate {
    
    var products: [NVPProduct]? = NVPProduct.getProducts(nil)
    var selectProduct: NVPProduct?
    
    var currentOperation: NSOperation?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        products = NVPProduct.getProducts(nil)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.tableHeaderView = myView
        
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
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableCellWithIdentifier("cellTitle") {
            return headerView
        }
  
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CellForPriceTableViewCell
        
        
        if let products = products {
            
            let product = products[indexPath.row]
            
            cell.productTitle.text = product.name
            cell.price1.text = "\(product.price1.doubleValue)"
            cell.price2.text = "\(product.price2.doubleValue)"
            cell.price3.text = "\(product.price3.doubleValue)"
            cell.price4.text = "\(product.price4.doubleValue)"
            
            
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
}

