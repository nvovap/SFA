//
//  InfoForStoryViewController.swift
//  Vega3
//
//  Created by Владимир Невинный on 07.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class InfoForStoryViewController: UIViewController {
    
    var story: NVPStore?
    
    @IBOutlet weak var textInfo: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let infoStory = story?.info {
             textInfo.text = infoStory.info
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
       

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print(segue.identifier)
    }
    

}
