//
//  GIJSONResponseSerializer.m
//  Gistr
//
//  Created by Karol Wojtaszek on 28.04.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "GIJSONResponseSerializer.h"

@implementation GIJSONResponseSerializer

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(200, 100)];
        [statusCodes addIndex:422];
        [statusCodes addIndex:403];
        
        [self setAcceptableStatusCodes:statusCodes];
        NSMutableSet *set = [self.acceptableContentTypes mutableCopy];
        [set addObject:@"text/plain"];
        [self setAcceptableContentTypes:set];
        
    }
    return self;
}

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    // get parsed JSON response
    NSDictionary *json = [super responseObjectForResponse:response data:data error:error];
    
    if (*error) {
        return nil;
    }
    
    if (response.statusCode == 403) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: json[@"description"], GIAPIErrroTitleKey: json[@"title"] };
        *error = [NSError errorWithDomain:GIAPIErrorDomain code:response.statusCode userInfo:userInfo];
        
        return nil;
    }

    // AFJSONResponseSerializer validation
    if (![self validateResponse:response data:data error:NULL]) {
        return nil;
    }
    
    // handle unprocessable entity error
    if (response.statusCode == 422) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: json[@"description"], GIAPIErrroTitleKey: json[@"title"] };
        *error = [NSError errorWithDomain:GIAPIErrorDomain code:response.statusCode userInfo:userInfo];
        
        return nil;
    }

    return json;
}

@end
