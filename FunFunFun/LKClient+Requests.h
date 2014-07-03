//
//  LKClient+Requests.h
//  FunFunFun
//
//  Created by Dev on 7/1/14.
//  Copyright (c) 2014 Dev. All rights reserved.
//

#import "LKClient.h"

@interface LKClient (Requests)

-(NSMutableURLRequest *) requestFollowedUsersListWithParameters: (NSDictionary*) params;

@end
