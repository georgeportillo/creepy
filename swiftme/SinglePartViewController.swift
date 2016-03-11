//
//  SinglePartViewController.swift
//  swiftme
//
//  Created by George Portillo on 3/8/16.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit

class SinglePartViewController: UIViewController {
    
    var singlePartData: Part!

    @IBOutlet weak var singlePartTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        singlePartTextView.text = singlePartData.title
        singlePartTextView.contentInset = UIEdgeInsetsMake(5.0,5.0,5,5.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
