//
//  P1PlayView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1PlayView.h"

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

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius withColor:(UIColor *)color inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 2*radius);
    [color setStroke];
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CGPoint point = [touches anyObject];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.tapPoint = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    //[self drawCircleAtPoint:self.tapPoint withRadius:10 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
}


@end
