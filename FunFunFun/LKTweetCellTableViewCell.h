//
//  LKTweetCellTableViewCell.h
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKTweetCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextView* mainContent;
@property (nonatomic, weak) IBOutlet UILabel * tweetAuthorLabel;
@property (nonatomic, weak) IBOutlet UILabel * tweetDateLabel;

@end
