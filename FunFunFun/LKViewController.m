//
//  LKViewController.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "LKViewController.h"



@interface LKViewController ()

@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tokenGetter = [[LKOAuthToken alloc] init];
    self.userPasswordTextField.secureTextEntry = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)logInWithTwitterAccount{
    self.tokenAndSecret = [self.tokenGetter getOAuthTokenAndSecret];
    NSLog(@"User's token: %@. User's secret: %@", [self.tokenAndSecret objectAtIndex:0], [self.tokenAndSecret objectAtIndex:1]);
    
}

-(IBAction)logInWithGivenUserNameAndPassword{
    if ([self.userNameTextField.text length] > 0 && [self.userPasswordTextField.text length] > 0) {
        self.tokenAndSecret = [self.tokenGetter getTokenAndSecretForUser:self.userNameTextField.text withPassword: self.userPasswordTextField.text];
        NSLog(@"User's token: %@. User's secret: %@", [self.tokenAndSecret objectAtIndex:0], [self.tokenAndSecret objectAtIndex:1]);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
