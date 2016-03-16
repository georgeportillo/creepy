//
//  ViewController.swift
//  swiftme
//
//  Created by George Portillo on 3/7/16.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMobileAds

import Bolts
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray = [Part]()
    
    let ImageHeight: CGFloat = 200.0
    let OffsetSpeed: CGFloat = 15.0

    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bobURL = NSURL(string: "http://bobisnothing.com/api/part")

        let request = NSURLRequest(URL: bobURL!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        bannerView.adUnitID = "ca-app-pub-8807766526289453/7977953619"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let task = session.dataTaskWithRequest(request, completionHandler:{
            data, response, err -> Void in
            if let data = NSData(contentsOfURL: bobURL!) {
                let jsonResult: NSArray! = (try? NSJSONSerialization.JSONObjectWithData(data, options:[])) as? NSArray
                for item in jsonResult {
                    self.dataArray.append(Part(json: item as! NSDictionary))
                }
                self.storyTableView.performSelectorOnMainThread(
                    Selector("reloadData"), withObject: nil, waitUntilDone: true)
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "singleStorySegue" {
            let indexPath = sender as! NSIndexPath
            let selectedStory = dataArray[indexPath.row]
            let mySingleStoryController = segue.destinationViewController as! SinglePartViewController
            mySingleStoryController.singlePartData = selectedStory
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("singleStorySegue", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell") as! MyTableViewCell
        cell.titleLabel.text = dataArray[indexPath.row].title
        asyncLoadStoryImage(dataArray[indexPath.row], imageView: cell.backgroundImageView)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let cells = storyTableView.visibleCells as! [MyTableViewCell]
        for parallaxCell in cells {
            let yOffset = ((storyTableView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
            parallaxCell.offset(CGPointMake(0.0, yOffset))
        }
    }
    
    func asyncLoadStoryImage(part: Part, imageView: UIImageView) {
        let downloadQueue = dispatch_queue_create("com.georgeportillo", nil)
        
        dispatch_async(downloadQueue) {
            let data = NSData(contentsOfURL: NSURL(string: part.image!)!)
            
            var imageFromData: UIImage?
            if data != nil {
                part.imageData = data
                imageFromData = UIImage(data: data!)!
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = imageFromData
            }
        }
    }
}