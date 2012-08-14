//
//  P1PlayView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1PlayView.h"
#import "P1Utils.h"

@implementation P1PlayView

@synthesize tapPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CGPoint point = [touches anyObject];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //self.tapPoint = [[touches anyObject] locationInView:self];
    //[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [P1Utils drawCircleAtPoint:self.tapPoint withRadius:10 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
}


@end
