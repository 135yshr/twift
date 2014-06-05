//
//  TimelineViewController.swift
//  Twift
//
//  Created by 135yshr on 2014/06/04.
//  Copyright (c) 2014 135yshr. All rights reserved.
//

import UIKit
import Twitter
import Accounts

class TimelineViewController: UITableViewController {
    
    var statuses = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let handler: ACAccountStoreRequestAccessCompletionHandler = {granted, error in
            if(!granted) {
                NSLog("ユーザーがアクセスを拒否しました。")
                return
            }

            let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
            if(twitterAccounts.count > 0){
                let account = twitterAccounts[0] as ACAccount
                let url = NSURL.URLWithString("https://api.twitter.com/1/statuses/home_timeline.json")
                let hendler: TWRequestHandler = {responseData, urlRes, error in
                    if(responseData == nil) {
                        NSLog("\(error)")
                        return
                    }
                    var error: NSErrorPointer = nil
                    self.statuses  =
                        NSJSONSerialization.JSONObjectWithData(responseData,
                            options: NSJSONReadingOptions.MutableLeaves, error: error) as NSArray
                    if(self.statuses == nil) {
                        NSLog("\(error)")
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
                }
                let request = TWRequest(URL: url, parameters: nil, requestMethod: TWRequestMethod.GET)
                request.account = account
                request.performRequestWithHandler(hendler)
            }
        }
        accountStore.requestAccessToAccountsWithType(twitterAccountType, handler)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return statuses.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!)
        -> UITableViewCell! {
            
        let CellIdentifier = "Cell"
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        cell.textLabel.font = UIFont.systemFontOfSize(11.0)

        let status: NSDictionary! = statuses[indexPath.row] as NSDictionary!
        let text = status.objectForKey("text") as String
        cell.textLabel.text = text

        return cell
    }

    @IBAction func pressComposeButton() {
        if(TWTweetComposeViewController.canSendTweet()) {
            let composeViewController = TWTweetComposeViewController()
            self.presentModalViewController(composeViewController, animated: true)
        }
    }
}

