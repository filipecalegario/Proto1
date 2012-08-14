//
//  P1AddObjectTableViewController.m
//  Proto1
//
//  Created by Filipe Calegario on 19/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1AddObjectTableViewController.h"

@interface P1AddObjectTableViewController ()

@end

@implementation P1AddObjectTableViewController

@synthesize editViewController = _editViewController;
@synthesize tapLocation = _tapLocation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Opa!");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(cell.reuseIdentifier);
    [self.editViewController addObject:cell.reuseIdentifier];
}

@end
