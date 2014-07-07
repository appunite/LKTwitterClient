//
//  LKTweet.m
//  FunFunFun
//
//  Created by Dev on 7/7/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//


#import "LKTweet.h"

@implementation LKTweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"author": @"user.username",
             @"content": @"text",
             @"createdAt": @"created_at",
             @"usersAvatarImageURL": @"user.avatar_image.url"
             };
}

+ (NSValueTransformer *)URLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
