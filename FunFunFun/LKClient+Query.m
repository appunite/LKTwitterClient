//
//  LKClient+Query.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient+Query.h"
#import "LKClient+Requests.h"

#import "LKFriendsIDsSerializer.h"

@implementation LKClient (Query)

+(void)fetchFollowedUsersIDsWithParameters: (NSDictionary *) params{
    
    NSMutableURLRequest *request = [[LKClient operationManager] requestFollowedUsersListWithParameters:params];
    
    
}

@end
