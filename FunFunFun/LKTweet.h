//
//  LKTweet.h
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKTwitterAuthor.h"

@interface LKTweet : NSObject

@property (nonatomic, strong) NSString *tweetContent;
@property (nonatomic, strong) LKTwitterAuthor *tweetAuthor;

@end
