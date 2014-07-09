//
//  LKTwitterClient.h
//  FunFunFun
//
//  Created by Dev on 7/7/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@protocol LKTwitterClientDelegate;
@interface LKTwitterClient : NSObject

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic) BOOL accessToTwitterAccountGranted;
@property (nonatomic, weak) id <LKTwitterClientDelegate> delegate;


-(void)postTweetWithContent:(NSString *)content;
-(void)getUserTweetsWithCompletionHandler:(void(^)(BOOL success, NSArray* tweets, NSError *error))handler;


@end


@protocol LKTwitterClientDelegate <NSObject>

@optional
-(void)postTwitterAccessDenialInfo;
-(void)tweetWasSuccessfullyPosted;
-(void)printError:(NSString *)error;

@end


@interface LKTwitterClient (Requests)

-(SLRequest *)requestPostStatusUpdate:(NSString*)update;

-(SLRequest *)requestGetUserTweets;

@end
