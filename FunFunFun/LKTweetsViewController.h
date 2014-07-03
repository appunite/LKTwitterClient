//
//  LKTweetsViewController.h
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKTweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tweetsTableView;
@property (nonatomic, strong) NSMutableArray *tweetsArray;

@end
