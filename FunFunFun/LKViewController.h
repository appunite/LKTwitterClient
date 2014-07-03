//
//  LKViewController.h
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKOAuthToken.h"

@interface LKViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet UITextField *userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *userPasswordTextField;
@property (nonatomic, strong) LKOAuthToken *tokenGetter;
@property (nonatomic, strong) NSArray * tokenAndSecret;

@end
