//
//  LKViewController.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "LKViewController.h"
#import "LKTweetCellTableViewCell.h"



@interface LKViewController ()

@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showTweets{

    [LKClient getTwitterGlobalFeedWithHandler:^(BOOL succes, NSArray* data, NSError *error) {
        if (succes){
            for (int i=0; i<[data count]; ++i){
                NSDictionary *tweetData = [data objectAtIndex:i];
                
                NSError *error;
                
                LKTweet *tweet = [MTLJSONAdapter modelOfClass:LKTweet.class
                                         fromJSONDictionary:tweetData
                                                      error:&error];
                
                NSLog(@"Dodano tweeta: %@", tweet);
                [self.tweets addObject:tweet];
                [self.tweetsTableView reloadData];
            }
            [self.tweetsTableView reloadData];
        }
    }];
    
}

-(IBAction)postTweet{
    
    if (!self.twitterClient) self.twitterClient = [[LKTwitterClient alloc] init];
    
    [self.twitterClient postTweetWithContent:@"Test tweet"];
    
    /*if ([self.userNameTextField.text length] > 0 && [self.userPasswordTextField.text length] > 0) {
        self.tokenAndSecret = [self.tokenGetter getTokenAndSecretForUser:self.userNameTextField.text withPassword: self.userPasswordTextField.text];
        NSLog(@"User's token: %@. User's secret: %@", [self.tokenAndSecret objectAtIndex:0], [self.tokenAndSecret objectAtIndex:1]);
    }*/
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITable View Delegate&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"Tweet cell";
    LKTweetCellTableViewCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:cellID];
    LKTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    cell.mainContent.text = tweet.content;
    // Set up cell properites!
    
    return cell;
}

@end
