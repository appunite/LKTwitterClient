//
//  LKTwitterClient.m
//  FunFunFun
//
//  Created by Dev on 7/7/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKTwitterClient.h"

@implementation LKTwitterClient

/*-(void)requestAccessToTwitterAccount{
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
}*/

//-(instancetype) init{
  //  self.delegate
//}

-(void)postTweetWithContent:(NSString *)content{
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc]init];
    
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error){
        
        if(granted){
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            
            ACAccount *account = [accounts objectAtIndex:0];
            
            NSURL *postStatusUpdateURL = [NSURL URLWithString:kUpdateTwitterStatusURL];
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:postStatusUpdateURL parameters:@{@"status":content}];
            
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
/*
-(void)postTweetWithContent:(NSString *)content{
    if (!self.accountStore) self.accountStore = [[ACAccountStore alloc]init];
    
    NSString *usrName = @"user";
    
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error){
        
        NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
        
        ACAccount *account = [accounts objectAtIndex:0];
        
        NSURL *usersShowURL = [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:usersShowURL parameters:[NSDictionary dictionaryWithObject:usrName forKey:@"screen_name"]];
        
        
        [request setAccount:account];
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            NSDictionary *userObject = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
            
            NSString *geoEnabled = [userObject objectForKey:@"geo_enabled"];
            
            if(!geoEnabled){
                NSURL *statusUpdateURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                
                //Byc moze wroce sobie pozniej do tego i zrobie pobieranie wspolrzednych.
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        content, @"status",
                                        @"37.7821120598956", @"lat", @"-122.400612831116",
                                        @"long",
                                        nil];
                
                SLRequest *requestWithGeo = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:statusUpdateURL parameters:params];
                
                [requestWithGeo setAccount:account];
                
                [requestWithGeo performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
                    NSLog(@"%@", dict);
                    
                }];
            } else
                NSLog(@"Localization services not enabled");
        }];
        
    }];
}
*/
@end
