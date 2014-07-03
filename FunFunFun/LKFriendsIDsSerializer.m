//
//  LKFriendsIDsSerializer.m
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKFriendsIDsSerializer.h"

@implementation LKFriendsIDsSerializer

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error{
    NSDictionary *friendsJSON = [super responseObjectForResponse:response data:data error:error];
    
    NSArray *friends = [friendsJSON objectForKey:@"ids"];
    
    return friends;
}


@end
