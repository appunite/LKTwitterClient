//
//  LKOAuthToken.h
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTwitterAPI.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "LKFunctions.h"
#include "constants.h"

@interface LKOAuthToken : NSObject

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) STTwitterAPI *twitter;


-(NSArray *)getOAuthTokenAndSecret;

-(NSArray *) getTokenAndSecretForUser: (NSString *) user withPassword: (NSString *)password;

-(NSString *)getAuthorizationHeaderForHTTPMethod: (NSString *)method forBaseURL: (NSString *) URL;


@end
