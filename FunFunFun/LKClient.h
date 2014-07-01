//
//  LKClient.h
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AUAccount.h"

@interface LKClient : AFHTTPRequestOperationManager

+(instancetype)operationManager;

+(void)enqueueOperation:(NSOperation *)operation;


@end
