//
//  LKOAuthToken.m
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKOAuthToken.h"

@interface LKOAuthToken()

@property (nonatomic, strong) NSString *oauthNonce;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *tokenSecret;

@end

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
    [reqTokenParams setValue:CONSUMER_KEY forKey:@"oauth_consumer_key"];
    [reqTokenParams setValue:[LKFunctions randomStringWithLength:32] forKey:@"oauth_nonce" ];
    [reqTokenParams setValue:@"HMAC-SHA1" forKey:@"oauth_signature_method"];
    [reqTokenParams setValue:[LKFunctions sinceUnixEpochString] forKey:@"oauth_timestamp" ];
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
 

////////////////////////////////////////////////
////////////////////////////////////////////////
//
// GET TOKEN WITH USERNAME AND PASSWORD
//
////////////////////////////////////////////////
////////////////////////////////////////////////


-(NSArray *) getTokenAndSecretForUser: (NSString *) user withPassword: (NSString *)password{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET username:user password:password];
    
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


////////////////////////////////////////////////
////////////////////////////////////////////////
//
// GET AUTH HEADER
//
////////////////////////////////////////////////
////////////////////////////////////////////////

/*
-(NSString *)getAuthorizationHeaderForHTTPMethod: (NSString *)method forBaseURL: (NSString *) URL
{
    
    self.timeStamp = [LKFunctions sinceUnixEpochString];
    self.oauthNonce = [LKFunctions randomStringWithLength:32];
    NSString *signature = [self getOauthSignatureForHTTPMethod:method forBaseURL:URL];
    
    NSMutableString *string = [NSMutableString string];
    
     NSArray *keys = @[@"oauth_consumer_key", @"oauth_nonce", @"oauth_signature", @"oauth_signature_method", @"oauth_timestamp", @"oauth_token", @"oauth_version"];
     //NSArray *values = @[CONSUMER_SECRET_QUOTATION, ];
    
    
    
    //NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:CONSUMER_KEY, @"oauth_consumer_key", self.oauthNonce, @"oauth_nonce", signature, @"oauth_signature", OAUTH_SIGNATURE_METHOD, @"oauth_signature_method", self.timeStamp, @"oauth_timestamp", self.token, @"oauth_token", @"1.0", @"oauth_version", nil];
    
    
     return string;
}
*/

//CALCULATED WITH SIGNATURE BASE STRING AND SIGNING KEY

/*-(NSString *)getOauthSignatureForHTTPMethod: (NSString *)HTTPMethod forBaseURL: (NSString *) URL
{
    NSString *hmac = [self getSignatureBaseStringWithHTTPMethod:HTTPMethod forBaseURL:URL];
    NSString *key = [self getSigningKey];
    return [LKFunctions hmacsha1:hmac secret:key];
}*/


////////////////////////////////////////////////
////////////////////////////////////////////////
//
// CREATE SIGNATURE ELEMENTS
//
////////////////////////////////////////////////
////////////////////////////////////////////////

-(NSString *)getSigningKey{
    //Percent encoded consumer secret & percent encoded token secret
    NSMutableString *str = [NSMutableString string];
    [str appendString:[LKFunctions percentEncodeString:CONSUMER_SECRET]];
    [str appendString:@"&"];
    [str appendString:[LKFunctions percentEncodeString:self.tokenSecret]];
    
    return str;
}

-(NSString *)getPametersString{
    
    NSMutableArray *keys = [NSMutableArray arrayWithObjects:@"include_entities", @"oauth_consumer_key", @"oauth_nonce", @"oauth_signature_method", @"oauth_timestamp", @"oauth_token", @"oauth_version", nil];
    NSMutableArray *values = [NSMutableArray arrayWithObjects:@"true", CONSUMER_KEY, self.oauthNonce, OAUTH_SIGNATURE_METHOD, self.timeStamp, self.token, @"1.0", nil];
    
    for (int i = 0; i<[keys count]; ++i){
        keys[i] = [LKFunctions percentEncodeString:[keys objectAtIndex:i]];
        values[i] = [LKFunctions percentEncodeString:[values objectAtIndex:i]];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    [keys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableString *paramsString = [NSMutableString string];
    
    for (NSString *key in keys){
        [paramsString appendString:key];
        [paramsString appendString:@"="];
        [paramsString appendString:[params objectForKey:key]];
    }
    
    NSRange range = NSMakeRange([keys count]-1, 1);
    
    [paramsString deleteCharactersInRange:range];
    
    return paramsString;
    
}

-(NSString *)getSignatureBaseStringWithHTTPMethod: (NSString *) method forBaseURL:(NSString *)baseURL {
    NSMutableString *signatureBaseString = [NSMutableString string];
    NSString *params = [self getPametersString];
    
    [signatureBaseString appendString:method];
    [signatureBaseString appendString:@"&"];
    [signatureBaseString appendString:[LKFunctions percentEncodeString:baseURL]];
    [signatureBaseString appendString:@"&"];
    [signatureBaseString appendString:[LKFunctions percentEncodeString:params]];
    
    return signatureBaseString;
}








@end
