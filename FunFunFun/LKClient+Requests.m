//
//  LKClient+Requests.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient+Requests.h"

@implementation LKClient (Requests)

- (NSMutableURLRequest *)requestGetTweetsFromGlobalFeed{
    
    return [self.requestSerializer requestWithMethod:@"GET"
                                           URLString:kGlobalFeedURL
                                          parameters:nil
                                               error:NULL];
}

@end
