//
//  LKUserTweetsVC.h
//  FunFunFun
//
//  Created by Dev on 7/8/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTwitterClient.h"
#import "LKTweet.h"
#import "LKTweetCellTableViewCell.h"

@interface LKUserTweetsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tweetsTableView;

@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, strong) UIRefreshControl * refresh;

@property (nonatomic, strong) LKTwitterClient * twitterClient;
@property (nonatomic, strong) NSMutableArray *userTweetsArray;

@end
