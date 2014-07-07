//
//  LKClient.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient.h"

@implementation LKClient

+ (void)enqueueOperation:(NSOperation *)op {
    [[[LKClient manager] operationQueue] addOperation:op];
}

+ (void)enqueueRequest:(NSURLRequest *)request responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // create operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = responseSerializer;
    
    // set onSuccess and onFailure blocks
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    // enqueue operation
    [LKClient enqueueOperation:operation];
}







@end
