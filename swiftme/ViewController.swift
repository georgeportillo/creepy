//
//  ViewController.swift
//  swiftme
//
//  Created by George Portillo on 3/7/16.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray = [Part]()
    
    let ImageHeight: CGFloat = 200.0
    let OffsetSpeed: CGFloat = 25.0

    @IBOutlet weak var storyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let bobURL = NSURL(string: "http://bobisnothing.com/api/part")
        
        if let JSONData = NSData(contentsOfURL: bobURL!) {
            let jsonResult: NSArray! = (try? NSJSONSerialization.JSONObjectWithData(JSONData, options:[])) as? NSArray
            for item in jsonResult {
                dataArray.append(Part(json: item as! NSDictionary))
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
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