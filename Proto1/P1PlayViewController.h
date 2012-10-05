//
//  P1PlayViewController.h
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdDispatcher.h"
#import "PdFile.h"
#import "P1PlayView.h"
#import <VVOSC/VVOSC.h> 

@interface P1PlayViewController : UIViewController <UIGestureRecognizerDelegate, OSCDelegateProtocol>
{
    PdDispatcher *dispatcher;
    NSMutableArray* patches;
}

@property (weak, nonatomic) IBOutlet P1PlayView *playArea;
@property (nonatomic, strong) NSArray* objectArray;

@property (nonatomic, strong) NSArray* patchesToLoad;

@property (nonatomic, strong) UIImage * backgroundForPlayArea;

- (void)touch:(UIPanGestureRecognizer *)gesture;

- (void)aMethod:(UIButton *)sender;
- (void)populateArray:(NSArray *)objectArray;
- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture;
- (void)panOnTheButtonAction:(UIPanGestureRecognizer *)gesture;
- (void)panOnEverything:(UIPanGestureRecognizer *)gesture;
- (void)playTouchableAction:(UITapGestureRecognizer *)gesture;

-(void)receivedOSCMessage:(OSCMessage *)m;

@end
