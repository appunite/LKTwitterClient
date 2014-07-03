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
        
        [jsonRequestSerializer setValue:authToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
    };
    
    // setup default headers
    [jsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [jsonRequestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [jsonRequestSerializer setValue:@"4" forHTTPHeaderField:@"X-API-VERSION"];
    
#ifdef STAGING
    [httpManager.securityPolicy setValidatesCertificateChain:NO];
    [httpManager.securityPolicy setValidatesDomainName:NO];
    [httpManager.securityPolicy setAllowInvalidCertificates:YES];
#endif
    
    //user agent
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];
    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@/Apple;%@", [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"], device];
    [jsonRequestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    // set gziped JSON request serializer as default
    [httpManager setRequestSerializer:[AFgzipRequestSerializer serializerWithSerializer:jsonRequestSerializer]];
    
    if ([[AUAccount account] isLoggedIn]) {
        // update `X-AUTH-TOKEN`
        authTokenBlock();
    }
    
    // we should invalidate that value on every login
    [[NSNotificationCenter defaultCenter] addObserverForName:AUAccountDidLoginUserNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // update `X-AUTH-TOKEN`
        authTokenBlock();
    }];
    
    // handle error globally
    [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidFinishNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[note object];
        
        // get response status code
        NSInteger statusCode = (NSInteger)[operation.response statusCode];
        
        // send error to Crashlytics if needed
        if (![operation.responseSerializer.acceptableStatusCodes containsIndex:statusCode] && statusCode > 99 && statusCode != 404) {
            NSLog(@"HTTP Error: %lu, curl: %@", (long)[operation.response statusCode], [TTTURLRequestFormatter cURLCommandFromURLRequest:operation.request]);
        }
    }];
    
    return httpManager;
}

+ (void)enqueueOperation:(NSOperation *)op {
    [[[LKClient operationManager] operationQueue] addOperation:op];
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
