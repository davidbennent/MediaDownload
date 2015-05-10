//
//  ViewController.swift
//  MediaDownload
//
//  Created by David Bennet on 2/11/15.
//  Copyright (c) 2015 David Bennet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, MBProgressHUDDelegate {

    var arrMedia: NSMutableArray = NSMutableArray()
    var HUD: MBProgressHUD!
    var downloadRequest: Request!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var mediumCell: MediumTableViewCell!
    
    // MARK: Override methods
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItemRefresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "buttonRefreshTapped") as UIBarButtonItem
        self.navigationItem.rightBarButtonItem = barButtonItemRefresh
        
        initialize()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Custom functions
    
    func initialize() {
        arrMedia.removeAllObjects()
        
        var mediumObject = MediumObject()
        mediumObject.isVideo = false
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/EdrzDamixxk/1.jpg"
        mediumObject.fullPath = "http://img.youtube.com/vi/EdrzDamixxk/0.jpg"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = false
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/oM-XJD4J36U/1.jpg"
        mediumObject.fullPath = "http://img.youtube.com/vi/oM-XJD4J36U/0.jpg"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = false
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/i8q8fFs3kTM/1.jpg"
        mediumObject.fullPath = "http://img.youtube.com/vi/i8q8fFs3kTM/0.jpg"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = false
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/JU_6A23NvUg/1.jpg"
        mediumObject.fullPath = "http://img.youtube.com/vi/JU_6A23NvUg/0.jpg"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = false
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/lzAaYrNjSUI/1.jpg"
        mediumObject.fullPath = "http://img.youtube.com/vi/lzAaYrNjSUI/0.jpg"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = true
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/1yw1Tgj9-VU/1.jpg"
        mediumObject.fullPath = "http://www.quirksmode.org/html5/videos/big_buck_bunny.mp4"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = true
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/E4KWP6PirQE/1.jpg"
        mediumObject.fullPath = "http://playground.html5rocks.com/samples/html5_misc/chrome_japan.mp4"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = true
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/ScNNfyq3d_w/1.jpg"
        mediumObject.fullPath = "http://download.wavetlan.com/SVV/Media/HTTP/H264/Other_Media/H264_test5_voice_mp4_480x360.mp4"
        arrMedia.addObject(mediumObject)
        
        mediumObject = MediumObject()
        mediumObject.isVideo = true
        mediumObject.thumbnailPath = "http://img.youtube.com/vi/LYU-8IFcDPw/1.jpg"
        mediumObject.fullPath = "http://techslides.com/demos/sample-videos/small.mp4"
        arrMedia.addObject(mediumObject)
    }
    
    func showProgressBar() {
        
        HUD = MBProgressHUD(view: self.navigationController?.view)
        self.navigationController?.view.addSubview(HUD)
        HUD.show(true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTapped:")
        HUD.addGestureRecognizer(tapGestureRecognizer)
        
        HUD.delegate = self
        HUD.labelText = "Downloading...";
    }
    
    // MARK: UITableViewDelegate, Datasource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Utils.screenWidth() * 3 / 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMedia.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MediumTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as? MediumTableViewCell
        if cell == nil {
            NSBundle.mainBundle().loadNibNamed("MediumTableViewCell", owner: self, options: nil)
            cell = self.mediumCell
        }
        
        let mediumObject: MediumObject = arrMedia.objectAtIndex(indexPath.row) as MediumObject
        
        // show thumbnail image
        cell?.thumbnailImageView.frame = CGRectMake(0, 0, Utils.screenWidth(), Utils.screenWidth() * 3/4)
        cell?.thumbnailImageView.loadImageFromURL(NSURL(string: mediumObject.thumbnailPath))

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let mediumObject: MediumObject = arrMedia.objectAtIndex(indexPath.row) as MediumObject
        
        // check if already saved.
        let downloadFileURL = Utils.downloadFileURL(mediumObject)
        if NSFileManager.defaultManager().fileExistsAtPath(downloadFileURL.path!) {
            // show preview
            let previewVC = PreviewViewController(nibName: "PreviewViewController", bundle:nil)
            previewVC.mediumObject = mediumObject
            self.navigationController?.pushViewController(previewVC, animated: true)
            return
        }
        
        // show progres bar
        showProgressBar()
        
        // delete the downloaded file before download
        NSFileManager.defaultManager().removeItemAtURL(Utils.downloadedFileURL(), error: nil)
        
        // download file
        self.downloadRequest = download(.GET, mediumObject.fullPath as String, { _ in Utils.downloadedFileURL() }).progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
            
            // change progress value
            if (totalBytesExpectedToRead > 0) {
                self.HUD.mode = MBProgressHUDModeAnnularDeterminate
                self.HUD.progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
            }
        }.response { (request, response, _, error) in
            self.HUD.hide(true)
            if (error == nil && response != nil && response?.statusCode == 200) {
                NSLog("success")

                // show preview
                let previewVC = PreviewViewController(nibName: "PreviewViewController", bundle:nil)
                previewVC.mediumObject = mediumObject
                self.navigationController?.pushViewController(previewVC, animated: true)
                
            } else {
                var errorDescription = error?.localizedDescription
                NSLog("Downloading failed: %@", errorDescription!)
            }
        }
        
    }
    
    // MARK - MBProgressBar Delegate
    func hudWasHidden(hud: MBProgressHUD!) {
        HUD.removeFromSuperview()
        self.downloadRequest.cancel()
    }

    // MARK - IBAction methods
    
    @IBAction func buttonRefreshTapped() {
        Utils.removeAllDownloadedFiles()
        AsyncImageView.clearCache()
        self.tableView.reloadData()
    }
    
    // MARK: UITapGesture Recognizer methods
    func handleSingleTapped(recognizer: UITapGestureRecognizer) {
        HUD.hide(true)
    }
}

