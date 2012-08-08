//
//  P1TouchGestureRecognizer.m
//  Proto1
//
//  Created by Filipe Calegario on 08/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1TouchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation P1TouchGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateBegan];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateChanged];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateEnded];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateCancelled];
}

@end
