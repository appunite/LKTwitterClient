//
//  LKUserTweetsVC.m
//  FunFunFun
//
//  Created by Dev on 7/8/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKUserTweetsVC.h"

@interface LKUserTweetsVC ()

@end

@implementation LKUserTweetsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;
    if (!self.userTweetsArray) self.userTweetsArray = [[NSMutableArray alloc]init];
    
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.tweetsTableView.contentInset = UIEdgeInsetsMake(barHeight, 0, 0, 0);
    
    [self.navigationItem setTitle:@"My timeline"];
    
    //PULL TO REFRESH
    
    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.tweetsTableView;
    
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.tintColor = [UIColor grayColor];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    [self.refresh addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    
    self.tableViewController.refreshControl = self.refresh;
    
    //LOAD TWEETS
    
    [self loadTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTweets{
    
    if (!self.twitterClient) NSLog(@"No twitter client instance has been created.");
    
    [self.twitterClient getUserTweetsWithCompletionHandler:^(BOOL success, NSArray *tweets, NSError *error) {
        NSLog(@"Tried to obtain user's tweets.");
        if (success) {
            NSLog(@"Request was successful.");
            for (int i=0; i<[tweets count]; ++i){
                NSDictionary *tweetData = [tweets objectAtIndex:i];
                
                NSError *error;
                
                LKTweet *tweet = [MTLJSONAdapter modelOfClass:LKTweet.class
                                           fromJSONDictionary:tweetData
                                                        error:&error];

                
                NSLog(@"Dodano tweeta: %@", tweet);
                NSLog(@"Zawartosc tweeta: %@", tweet.content);
                [self.userTweetsArray addObject:tweet];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tweetsTableView reloadData];
                });
            }
            //[self.tweetsTableView reloadData];
        }
    }];
    [self.refresh endRefreshing];
}

#pragma mark - Table View Data Source & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userTweetsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"Tweet cell";
    LKTweetCellTableViewCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:cellID];
    LKTweet *tweet = [self.userTweetsArray objectAtIndex:indexPath.row];
    cell.mainContent.text = tweet.content;
    NSLog(@"Tweet's content: %@", tweet.content);
    cell.tweetDateLabel.text = [[LKFunctions dateFormatter] stringFromDate:tweet.createdAt];
    // Set up cell properites!
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
