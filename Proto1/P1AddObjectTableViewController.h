//
//  P1AddObjectTableViewController.h
//  Proto1
//
//  Created by Filipe Calegario on 19/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1EditViewController.h"

@interface P1AddObjectTableViewController : UITableViewController

@property (nonatomic, strong) P1EditViewController* editViewController;
@property (nonatomic, assign) CGPoint tapLocation;

@end
