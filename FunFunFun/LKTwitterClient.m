//
//  LKTwitterClient.m
//  FunFunFun
//
//  Created by Dev on 7/7/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKTwitterClient.h"

@implementation LKTwitterClient



-(void)postTweetWithContent:(NSString *)content{
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc]init];
    
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error){
        
        if(granted){
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            
            ACAccount *account = [accounts objectAtIndex:0];
            
            SLRequest *request = [self requestPostStatusUpdate:content];
            
            [request setAccount:account];
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (!error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate tweetWasSuccessfullyPosted];
                    });
                }
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
                NSLog(@"%@", dict);
                NSArray *errors = [dict objectForKey:@"errors"];
                if (errors){
                    NSDictionary *error = [errors objectAtIndex:0];
                        NSString *message = [error objectForKey:@"message"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate printError:message];
                        });
                    
                }
            }];
        }
        else {
            NSLog(@"Access to Twitter account denied.");
            [self.delegate postTwitterAccessDenialInfo];
        }
        
    }];
}

-(void)getUserTweetsWithCompletionHandler:(void (^)(BOOL success, NSArray* tweets, NSError *))handler{
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc]init];
    
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error){
        
        if(granted){
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            
            ACAccount *account = [accounts objectAtIndex:0];
            
            SLRequest *request = [self requestGetUserTweets];
            
            NSLog(@"Request: %@", request);
            
            [request setAccount:account];
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                NSArray *tweets = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
                //NSLog(@"Response dictionary: %@", response);
                //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:responseData];
                //NSArray *tweets = [response objectForKey:@"data"];
                NSLog(@"Tweets array: %@", tweets);
                if (tweets){
                    handler(YES, tweets, error);
                }
                //Change value for error.
                else handler(NO, nil, nil);
            }];
        }
        else {
            NSLog(@"Access to Twitter account denied.");
            //Change value for error.
            handler(NO, nil, nil);
        }
        
    }];
}



@end








@implementation LKTwitterClient (Requests)

-(SLRequest *)requestPostStatusUpdate:(NSString*)update{
    NSURL *url = [NSURL URLWithString:kUpdateTwitterStatusURL];
    return [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:@{@"status":update}];
}

-(SLRequest *)requestGetUserTweets{
    NSURL *url = [NSURL URLWithString:kGetUserTweetsURL];
    return [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:nil];
}

@end
