//
//  LKClient+Query.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient+Query.h"
#import "LKClient+Requests.h"
#import "GIJSONResponseSerializer.h"

@implementation LKClient (Query)

+(void)getTwitterGlobalFeedWithHandler:(void(^)(BOOL succes, NSArray *data, NSError *error))handler{
    NSMutableURLRequest *request = [[LKClient manager] requestGetTweetsFromGlobalFeed];
    
    [LKClient enqueueRequest:request responseSerializer:[AFJSONResponseSerializer serializer] success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *response = [[NSDictionary alloc] initWithDictionary:responseObject];
        NSArray *data = [response objectForKey:@"data"];
        
        handler(YES, data, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(NO, nil,  error);
    }];
    
}


@end
