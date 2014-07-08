//
//  LKTweetCellTableViewCell.h
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKTweetCellTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextView* mainContent;
@property (nonatomic, strong) IBOutlet UILabel * tweetAuthorLabel;
@property (nonatomic, strong) IBOutlet UILabel * tweetDateLabel;

@end
