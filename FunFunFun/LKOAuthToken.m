//
//  LKOAuthToken.m
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKOAuthToken.h"

@implementation LKOAuthToken


////////////////////////////////////////////////
////////////////////////////////////////////////
//
// GET TOKEN WITH ACCOUNTS API
//
////////////////////////////////////////////////
////////////////////////////////////////////////




-(NSArray *)getOAuthTokenAndSecret{
    NSString *accessToken = [self getRequestToken];
    NSDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"uMy9qV14RsgD4NLvDUO3p3UcC"
                   forKey:@"x_reverse_auth_target"];
    
    [params setValue:accessToken forKey:@"x_reverse_auth_parameters"];
    
    NSURL *url2 =
    [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    SLRequest *stepTwoRequest =
    [SLRequest requestForServiceType:SLServiceTypeTwitter
                       requestMethod:SLRequestMethodPOST
                                 URL:url2
                          parameters:params];
    
    // You *MUST* keep the ACAccountStore alive for as long as you need an
    // ACAccount instance. See WWDC 2011 Session 124 for more info.
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc] init];
    
    //  We only want to receive Twitter accounts
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:
     ACAccountTypeIdentifierTwitter];
    
    __block NSString* responseString;
    
    //  Obtain the user's permission to access the store
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error)
     {
         if (!granted) {
             // handle this scenario gracefully
         } else {
             // obtain all the local account instances
             NSArray *accounts =
             [self.accountStore accountsWithAccountType:twitterType];
             
             // for simplicity, we will choose the first account returned - in
             // your app, you should ensure that the user chooses the correct
             // Twitter account to use with your application.  DO NOT FORGET THIS
             // STEP.
             [stepTwoRequest setAccount:[accounts objectAtIndex:0]];
             
             // execute the request
             [stepTwoRequest performRequestWithHandler:^
              (NSData *responseData,
               NSHTTPURLResponse *urlResponse,
               NSError *error) {
                  responseString = [[NSString alloc] initWithData:responseData
                                        encoding:NSUTF8StringEncoding];
                  
                  // see below for an example response
                  NSLog(@"The user's info for your server:\n%@", responseString);
              }];
         }
     }];
    if (responseString){
        NSArray *componenets = [responseString componentsSeparatedByString:@"&"];
        NSArray *tokenKeyAndToken = [[componenets objectAtIndex:0] componentsSeparatedByString:@"="];
        NSString *token = [tokenKeyAndToken objectAtIndex:1];
        NSArray *secretKeyAndSecret = [[componenets objectAtIndex:1] componentsSeparatedByString:@"="];
        NSString *secret = [secretKeyAndSecret objectAtIndex:1];
        return @[token, secret];
    }
    else return nil;
}

//////////////////////////////////////////

-(NSString *) getRequestToken{
    NSMutableDictionary *reqTokenParams = [[NSMutableDictionary alloc] init];
    [reqTokenParams setValue:@"uMy9qV14RsgD4NLvDUO3p3UcC" forKey:@"oauth_consumer_key"];
    [reqTokenParams setValue:[self randomStringWithLength:32] forKey:@"oauth_nonce" ];
    [reqTokenParams setValue:@"HMAC-SHA1" forKey:@"oauth_signature_method"];
    NSString *sinceUnixEpoch = [NSString stringWithFormat:@"%d", (int)NSTimeIntervalSince1970 ];
    [reqTokenParams setValue:sinceUnixEpoch forKey:@"oauth_timestamp" ];
    [reqTokenParams setValue:@"1.0" forKey: @"oauth_version"];
    [reqTokenParams setValue:@"reverse_auth" forKey:@"x_auth_mode"];
    
    __block NSString *requestToken;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:reqTokenParams];
    
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc] init];
        
        ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:twitterType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error) {
                                         
                if (!granted) {
                    // handle this scenario gracefully
                } else {
                    // obtain all the local account instances
                    NSArray *accounts =[self.accountStore accountsWithAccountType:twitterType];
                    
                    // for simplicity, we will choose the first account returned - in
                    // your app, you should ensure that the user chooses the correct
                    // Twitter account to use with your application.  DO NOT FORGET THIS
                    // STEP.
                    [request setAccount:[accounts objectAtIndex:0]];
                    
                    // execute the request
                    [request performRequestWithHandler:^
                    (NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                     NSError *error) {
                    requestToken =
                    [[NSString alloc] initWithData:responseData
                    encoding:NSUTF8StringEncoding];
                        
                    // see below for an example response
                    NSLog(@"The user's info for your server:\n%@", requestToken);
                    }];
                }
            }];
    return requestToken;
        
}
 
 
 
-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length]) % [letters length]]];
    }
    
    return randomString;
}
 

////////////////////////////////////////////////
////////////////////////////////////////////////
//
// GET TOKEN WITH USERNAME AND PASSWORD
//
////////////////////////////////////////////////
////////////////////////////////////////////////


-(NSArray *) getTokenAndSecretForUser: (NSString *) user withPassword: (NSString *)password{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"uMy9qV14RsgD4NLvDUO3p3UcC" consumerSecret:@"zPH9eDZyQO7xs1nrROApH9LCUYtZ2s8Kc148TuEPDamg9sb3Cg" username:user password:password];
    
    __block NSArray *tokenAndSecret;
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        NSLog(@"-- access granted for %@", username);
        NSLog(@"-- oauthAccessToken %@", self.twitter.oauthAccessToken);
        NSLog(@"-- oauthAccessTokenSecret %@", self.twitter.oauthAccessTokenSecret);
        tokenAndSecret = @[self.twitter.oauthAccessToken, self.twitter.oauthAccessTokenSecret];
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
    }];
    
    return tokenAndSecret;
}


@end
