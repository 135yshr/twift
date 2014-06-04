//
//  TimelineViewController.swift
//  Twift
//
//  Created by 135yshr on 2014/06/04.
//  Copyright (c) 2014年 135yshr. All rights reserved.
//

import UIKit
import Twitter
import Accounts

class TimelineViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let handler: ACAccountStoreRequestAccessCompletionHandler = {granted, error in
            if(!granted) {
                NSLog("ユーザーがアクセスを拒否しました。")
            } else {
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                NSLog("twitterAccounts = %@", twitterAccounts)
                if(twitterAccounts.count>0){
                    let account = twitterAccounts[0] as ACAccount
                    NSLog("account = %@", account)
                }
            }
        }
        accountStore.requestAccessToAccountsWithType(twitterAccountType, handler)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressComposeButton() {
        if(TWTweetComposeViewController.canSendTweet()) {
            let composeViewController = TWTweetComposeViewController()
            self.presentModalViewController(composeViewController, animated: true)
        }
    }
}

