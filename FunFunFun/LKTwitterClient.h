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

@interface LKTwitterClient : NSObject

@property (nonatomic, strong) ACAccountStore *accountStore;

-(void)postTweetWithContent:(NSString *)content;


@end
