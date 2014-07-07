//
//  LKViewController.h
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKOAuthToken.h"
#import "LKTwitterClient.h"
#import "LKClient.h"
#import "LKClient+Query.h"
#import "LKTweet.h"

@interface LKViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) IBOutlet UITextField *tweetContent;
@property (nonatomic, strong) IBOutlet UITableView *tweetsTableView;
@property (nonatomic, strong) LKTwitterClient *twitterClient;

@property (nonatomic, strong) NSDictionary *responseDictionary;
@property (nonatomic, strong) NSMutableArray *tweets;

@end
