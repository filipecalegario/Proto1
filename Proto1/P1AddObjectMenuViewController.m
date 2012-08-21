//
//  P1AddObjectMenuViewController.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1AddObjectMenuViewController.h"

@interface P1AddObjectMenuViewController ()

@end

@implementation P1AddObjectMenuViewController

@synthesize editViewController = _editViewController;
@synthesize tapLocation = _tapLocation;

- (IBAction)addObject:(UIButton *)sender
{
    NSString* currentTitle = [sender currentTitle];
    //UIImage* otherIdentifier = sender.currentImage;
    //NSLog(currentTitle);
    [self.editViewController addObject:currentTitle];
}

@end
