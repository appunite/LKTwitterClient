//
//  NSString+Additions.m
//  FunFunFun
//
//  Created by Dev on 7/7/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+(NSString *)stringWithStringAndQotationMarks:(NSString *) string{
    return [NSString stringWithFormat:@"\%@\"", string];
}

+(NSString *)stringWithKeys:(NSArray *)keys sepratedBy:(NSString *) separator fromValues:(NSArray *)values endedBy:(NSString *)symbol{
    
    NSMutableString *string = [NSMutableString string];
    
    if ([keys count] == [values count]){
        for (int i = 0; i<[keys count]; ++i){
            [string appendString:keys[i]];
            [string appendString:separator];
            [string appendString:values[i]];
            [string appendString:symbol];
        }
        NSRange range = NSMakeRange([keys count]-1, 1);
        
        [string deleteCharactersInRange:range];
        
        return string;
    }
    else NSLog(@"Unable to create NSString from keys and values.");
    return nil;
}

@end
