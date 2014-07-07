//
//  LKTweet.h
//  FunFunFun
//
//  Created by Dev on 7/7/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import <Mantle.h>


@interface LKTweet : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *author;
@property (nonatomic) NSString *content;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *usersAvatarImageURL;

@end


