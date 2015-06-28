//
//  PreviewViewController.swift
//  MediaDownload
//
//  Created by David Bennet on 2/12/15.
//  Copyright (c) 2015 David Bennet. All rights reserved.
//


import UIKit
import MediaPlayer

class PreviewViewController: UIViewController {

    var mediumObject: MediumObject?
    var moviePlayer : MPMoviePlayerController?
    let fileManager = NSFileManager.defaultManager()
    
    @IBOutlet weak var imvPhoto: UIImageView!

    // MARK: Override methods
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure navigation bar
        self.navigationItem.title = "Preview"
        let barButtonItemSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "buttonSaveTapped") as UIBarButtonItem
        self.navigationItem.rightBarButtonItem = barButtonItemSave
        
        var fullPath = Utils.downloadedFileURL().path
        let downloadFileURL = Utils.downloadFileURL((self.mediumObject)!)
        if fileManager.fileExistsAtPath(downloadFileURL.path!) {
            fullPath = downloadFileURL.path
        }
        
        // play image or video
        if (mediumObject?.isVideo == false) {
            self.imvPhoto.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: fullPath!)!)!)
        } else {
            self.moviePlayer = MPMoviePlayerController(contentURL: NSURL(fileURLWithPath: fullPath!)!)
            self.moviePlayer?.shouldAutoplay = true
            self.moviePlayer?.controlStyle = MPMovieControlStyle.Embedded
            self.moviePlayer?.view.frame = CGRectMake(0, 0, Utils.screenWidth(), Utils.screenHeight())
            self.moviePlayer?.prepareToPlay()
            self.view.addSubview((self.moviePlayer?.view)!)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (mediumObject?.isVideo == true) {
            self.moviePlayer?.stop()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBAction Functions
    
    @IBAction func buttonSaveTapped() {
        let downloadFileURL = Utils.downloadFileURL((self.mediumObject)!)
        if fileManager.fileExistsAtPath(downloadFileURL.path!) {
            Utils.showMessage("Already saved.", title: "")
        } else {
            Utils.removeOldestFileIfNeeded()
            fileManager.copyItemAtURL(Utils.downloadedFileURL(), toURL: downloadFileURL, error: nil)
        }
    }
}
