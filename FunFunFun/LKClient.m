//
//  LKClient.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient.h"

@implementation LKClient

+(instancetype) operationManager{
    static LKClient *__staticInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
        __staticInstance = [LKClient httpManagerWithBaseURL:url];
    });
    
    return __staticInstance;
}

+(LKClient *)httpManagerWithBaseURL:(NSURL *)url{
    LKClient *httpManager = [[LKClient alloc] initWithBaseURL:url];
    
    AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    
    void (^authTokenBlock)(void) = ^{
        NSString *authToken = [[AUAccount account] authenticationToken:nil];
        
        [jsonRequestSerializer setValue:authToken forHTTPHeaderField:]
    }
    
}

@end
