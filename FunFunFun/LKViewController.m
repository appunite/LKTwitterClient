//
//  LKViewController.m
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "LKViewController.h"
#import "LKTweetCellTableViewCell.h"
#import "LKUserTweetsVC.h"



@interface LKViewController () <LKTwitterClientDelegate>

@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;
    self.twitterClient = [[LKTwitterClient alloc] init];
    
    self.tweets = [[NSMutableArray alloc] init];
    [self showTweets];
    
    //HIDING KEYBOARD
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGeneralView:)];
    [self.generalView addGestureRecognizer:tap];
    
    //PULL TO REFRESH
	
    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.tweetsTableView;
    
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.tintColor = [UIColor grayColor];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    [self.refresh addTarget:self action:@selector(showTweets) forControlEvents:UIControlEventValueChanged];
    
    self.tableViewController.refreshControl = self.refresh;
}

-(void)setTwitterClient:(LKTwitterClient *)twitterClient{
    _twitterClient = twitterClient;
    _twitterClient.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapOnGeneralView:(UITapGestureRecognizer *)sender{
    [self.tweetContent resignFirstResponder];
}


#pragma mark - IBActions

-(void)showTweets{
    [self.tweets removeAllObjects];
    [self.tweetsTableView reloadData];
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

    [self.refresh endRefreshing];
    
}

-(IBAction)postTweet{
    
    [self.twitterClient postTweetWithContent:self.tweetContent.text];
    
    [self.tweetContent resignFirstResponder];
}

-(IBAction)showUserTweets{
    LKUserTweetsVC *controller = [[UIStoryboard storyboardWithName:kiPhoneUserTweetsStoryboard bundle:nil] instantiateInitialViewController];
    
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"Push user timeline VC" source:self destination:controller performHandler:^(void) {
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [self prepareForSegue:segue sender:self];
    [segue perform];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Push user timeline VC"]) {
        LKUserTweetsVC * controller = segue.destinationViewController;
        controller.twitterClient = self.twitterClient;
    }
}

#pragma mark - UITable View Delegate&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Number o tweets: %lu", self.tweets.count);
    return [self.tweets count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"Tweet cell";
    LKTweetCellTableViewCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:cellID];
    LKTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    cell.mainContent.text = tweet.content;
    cell.tweetAuthorLabel.text = tweet.author;
    NSString *stringFromDate = [[LKFunctions dateFormatter] stringFromDate:tweet.createdAt];
    cell.tweetDateLabel.text = stringFromDate;
    NSLog(@"Tweet's content: %@", tweet.content);
    // Set up cell properites.
    
    
    return cell;
}

#pragma mark - LKTwitterClient Delegate Methods

-(void)postTwitterAccessDenialInfo{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Access denial" message:@"Access to Twitter account hasn't been granted for this app. Go to Settings->Privacy->Twitter to change this." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)tweetWasSuccessfullyPosted{
    self.tweetContent.text = @"";
}

-(void)printError:(NSString *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Couldn't post tweet" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



@end
