//
//  LKTwitterAuthor.h
//  FunFunFun
//
//  Created by Dev on 7/3/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKTwitterAuthor : NSObject

@property (nonatomic, strong) NSString* twitterUserName;
@property (nonatomic) NSInteger twitterUserID;
@property (nonatomic, strong) NSArray *followers;
@property (nonatomic, strong) NSArray *followed;

@end
