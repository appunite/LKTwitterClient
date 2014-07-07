//
//  LKFunctions.m
//  FunFunFun
//
//  Created by Dev on 7/4/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKFunctions.h"
#import "MF_Base64Additions.h"

@implementation LKFunctions

+(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64String];
    
    return hash;
}

+(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}


+(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i< len ; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length]) % [letters length]]];
    }
    
    return randomString;
}


+(NSString *)sinceUnixEpochString{
    return[NSString stringWithFormat:@"%d", (int)NSTimeIntervalSince1970 ];
}

//PRZETESTOWAC!!!

+(NSString *)percentEncodeString: (NSString *)SRC{
    
    const unsigned char *toEncode = (const unsigned char *)[SRC UTF8String];
    NSMutableString *DST = [[NSMutableString alloc] initWithString:@""];
    
    for (int i = 0; i< [SRC length]; ++i){
        const unsigned char character= toEncode[i];
        if ([self isInAllowedCharactersSet:character]) {
            [DST appendFormat:@"%c", character];
        }
        else if (character == ' ') [DST appendString:@"+"];
        else {
            [DST appendFormat:@"%%%02X", character];
        }
    }
    
    return DST;
}

+(BOOL)isInAllowedCharactersSet:(unichar)character {
    /*NSArray *allowedCharacters = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p",@"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"-", @".", @"_", @"~"];*/
    if ((character >= 0x30 && character <=0x39) || (character >= 0x41 && character <= 0x5A) || (character >=0x61 && character <= 0x7A) || character == 0x2D || character == 0x2E || character == 0x5F || character == 0x7E ) return YES;
    
    else return NO;
}

@end
