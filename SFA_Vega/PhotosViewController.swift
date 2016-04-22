//
//  PhotosViewController.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 29.08.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var assets = [PHAsset]()
    
    var inventory: NVPInventory? {
        didSet {
            if let inventory = inventory {
                if let photos = NVPVisitPhotos.getPhotos(inventory: inventory, sendToFTP: false) {
                    var indentifiers = [String]()
                    
                    
                    for  photoVisit: NVPVisitPhotos in photos {
                        indentifiers.append(photoVisit.photo)
                    }
                    
                    
                    let fetchOptions = PHFetchOptions()
                    
                    fetchOptions.predicate = NSPredicate(format: "localIdentifier IN %@", indentifiers)
                    
                    let assetResults = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
                    
                    //let imageManager = PHCachingImageManager()
                    
                    self.assets.removeAll()
                    
                    assetResults.enumerateObjectsUsingBlock { (object, count, stop) -> Void in
                        if let asset = object as? PHAsset {
                            self.assets.append(asset)
                        }
                    }
                    
                }
            }
        }
    }
    
    
    var date: NSDate = NSDate()
    
    @IBOutlet weak var addPhoto: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        if let inventory = inventory  {
            if inventory.confirmation == true || inventory.sent == true {
                addPhoto.enabled = false
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Photo
    @IBAction func addPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            let picker = UIImagePickerController()
            picker.delegate     = self
            picker.sourceType   = UIImagePickerControllerSourceType.Camera
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
    
        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let mediaPath = info[UIImagePickerControllerMediaMetadata]  as? NSDictionary
        
        print(mediaPath)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        
        
        
        if let originalImage = originalImage {
            
            
            var photoAsset = ""
            
            dispatch_async(dispatch_get_global_queue(priority, 0)) { () -> Void in
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(originalImage)
                    let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest()
                    
                    photoAsset = assetPlaceholder!.localIdentifier
                    
                    
                    albumChangeRequest.addAssets([assetPlaceholder!])
                    
                    
                    }, completionHandler: { (succes, error) -> Void in
                        if succes {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                print(error)
                                picker.dismissViewControllerAnimated(true, completion: nil)
                                
                                if let inventory = self.inventory {
                                    
                                    let newPhotoVisit = NVPVisitPhotos.insertPhoto(date: NSDate(), inventory: inventory, photo: photoAsset, namePhoto: photoAsset)
                                    
                                    try! newPhotoVisit.managedObjectContext?.save()
                                    
                                    let fetchOptions = PHFetchOptions()
                                    fetchOptions.predicate = NSPredicate(format: "localIdentifier = %@", photoAsset)
                                    
                                    let assetResults = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
                                    
                                    
                                    assetResults.enumerateObjectsUsingBlock { (object, count, stop) -> Void in
                                        if let asset = object as? PHAsset {
                                            self.assets.append(asset)
                                        }
                                    }
                                    
                                }
                                
                                self.collectionView?.reloadData()
                            })
                        }
                })
            }
        }
        
       
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sendFTP(sender: AnyObject) {
        /*let defaults = NSUserDefaults.standardUserDefaults()
        
        if let linkName = defaults.stringForKey("link") {
            if let user = defaults.stringForKey("user") {
                if let password = defaults.stringForKey("password") {
                    let link = "ftp://\(user):\(password)@\(linkName)/"
                   
                    if let photosVisit = photosVisit{
                        for foto in photosVisit {
                            let linkFTP = link+foto.namePhoto
                            
                            _ = WriteFTP(urlFTP: linkFTP, pathImage: foto.photo)
                        }
                    }
                    
                }
            }
        }*/
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let countFoto = assets.count
        
        return countFoto
    }
    
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        
        let asset = assets[indexPath.row]
        
        let manager = PHImageManager.defaultManager()
        
        print(asset.localIdentifier)
        
        
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 99, height: 99), contentMode: PHImageContentMode.AspectFit, options: nil) { (image, info) -> Void in
            imageView.image = image
        }
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
