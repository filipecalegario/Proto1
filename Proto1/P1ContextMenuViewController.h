//
//  P1ContextMenuViewController.h
//  Proto1
//
//  Created by Filipe Calegario on 19/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1EditViewController.h"
#import "P1InputObjectView.h"

@interface P1ContextMenuViewController : UIViewController

@property (nonatomic, strong) P1EditViewController* editController;
@property (nonatomic, strong) P1InputObjectView* objectView;

@end
