//
//  LKClient+Requests.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient+Requests.h"

@implementation LKClient (Requests)

-(NSMutableURLRequest *) requestFollowedUsersListWithParameters: (NSDictionary*) params{
    return [self.requestSerializer requestWithMethod:@"GET" URLString:@"https://api.twitter.com/1.1/friends/ids.json" parameters:params error:NULL];
}

@end
