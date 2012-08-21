//
//  P1ContextMenuViewController.m
//  Proto1
//
//  Created by Filipe Calegario on 19/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1ContextMenuViewController.h"

@interface P1ContextMenuViewController ()

@end

@implementation P1ContextMenuViewController

@synthesize editController = _editController;
@synthesize objectView = _objectView;

- (IBAction)setThisNote:(UIButton *)sender {
    [self.editController configContextMenu:self.objectView withTag:sender.tag];
}

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
