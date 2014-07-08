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

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *usersAvatarImageURL;

@end


