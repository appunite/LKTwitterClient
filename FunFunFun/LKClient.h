//
//  LKClient.h
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AUAccount.h"
#import "AFgzipRequestSerializer.h"
#import "TTTURLRequestFormatter.h"
#import <sys/utsname.h>

@interface LKClient : AFHTTPRequestOperationManager

+(instancetype)operationManager;

+(void)enqueueOperation:(NSOperation *)operation;

+ (void)enqueueRequest:(NSURLRequest *)request
    responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
