//
//  LKFunctions.h
//  FunFunFun
//
//  Created by Dev on 7/4/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKFunctions : NSObject

//+(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
+(NSDateFormatter *)dateFormatter;
+(NSString *)randomStringWithLength: (int) len;
+(NSString *)sinceUnixEpochString;
+(NSString *)percentEncodeString: (NSString *)SRC;
+(BOOL)isInAllowedCharactersSet:(unichar)character ;



@end
