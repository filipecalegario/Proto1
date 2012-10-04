//
//  P1Touchable.m
//  Proto1
//
//  Created by Filipe Calegario on 06/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1Touchable.h"
#import "P1Utils.h"
#import "P1IconView.h"
#import <QuartzCore/QuartzCore.h>

#import <QuartzCore/CALayer.h>
#import <QuartzCore/CATransaction.h>

#define RESIZE_BUTTON_SIZE 44

@interface P1Touchable()

@property (nonatomic, assign) CGPoint translationPoint;

@end

@implementation P1Touchable

@synthesize editable;
@synthesize corner1;
@synthesize corner2;
@synthesize corner3;
@synthesize corner4;
@synthesize translationPoint;

- (id)initWithFrame:(CGRect)frame withCanvas:(P1EditView *)canvas
{
    
    P1IconView* icon = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withType:@"touchable" withColor:[P1Utils myColor:@"green"]];
    
    P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(100, 0, 50, 100) withType:@"trigger"];
    
    self = [super initWithFrame:frame withObjectType:INPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:NO];
    
    if (self) {
        [self setup];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame withCanvas:(P1EditView *)canvas withGroupedFlag:(BOOL)flag
{
    
    P1IconView* icon = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) withType:@"touchable" withColor:[P1Utils myColor:@"green"]];
    
    P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(50, 0, 50, 50) withType:@"trigger" withImageSource:@"specialConnector"];
    
    connector.transform = CGAffineTransformMakeRotation(M_PI);
    
    self = [super initWithFrame:frame withObjectType:INPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:flag];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(0, 0);
    self.frame = oldFrame;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapHandle:)];
    [self.icon addGestureRecognizer:longPress];
    
    [self.canvas.tapGesture requireGestureRecognizerToFail:longPress];
    
//    self.corner1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    self.corner1.backgroundColor = [P1Utils myColor:@"brown"];
//    
//    self.corner2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    self.corner2.backgroundColor = [P1Utils myColor:@"brown"];
    
    self.corner3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RESIZE_BUTTON_SIZE, RESIZE_BUTTON_SIZE)];
    self.corner3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"resize"]];//[P1Utils myColor:@"brown"];
    
//    self.corner4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    self.corner4.backgroundColor = [P1Utils myColor:@"brown"];
    
    //UIPanGestureRecognizer *panGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners1:)];
    //UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners2:)];
    UIPanGestureRecognizer *panGesture3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners3:)];
    //UIPanGestureRecognizer *panGesture4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners4:)];
    //[self.corner1 addGestureRecognizer:panGesture1];
    //[self.corner2 addGestureRecognizer:panGesture2];
    [self.corner3 addGestureRecognizer:panGesture3];
    //[self.corner4 addGestureRecognizer:panGesture4];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTouchesRequired = 2;
    doubleTap.numberOfTapsRequired = 2;
    [self.icon addGestureRecognizer:doubleTap];
    
    [self updateCorners];
    
    //[self addSubview:self.corner1];
    //[self addSubview:self.corner2];
    [self addSubview:self.corner3];
    //[self addSubview:self.corner4];
}

- (void) updateCorners
{
    
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    
    //self.corner1.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 20, 20);
    //self.corner2.frame = CGRectMake(self.icon.frame.origin.x + self.icon.frame.size.width - 20, self.bounds.origin.y, 20, 20);
    self.corner3.frame = CGRectMake(self.icon.frame.origin.x + self.icon.frame.size.width - RESIZE_BUTTON_SIZE, self.icon.frame.origin.y + self.icon.frame.size.height - RESIZE_BUTTON_SIZE, RESIZE_BUTTON_SIZE, RESIZE_BUTTON_SIZE);
    //self.corner4.frame = CGRectMake(self.bounds.origin.x, self.icon.frame.origin.y + self.icon.frame.size.height - 20, 20, 20);
    
//    [CATransaction commit];
}

- (void) longTapHandle:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        editable = !editable;
        [self setNeedsDisplay];
    }
}

- (void) doubleTap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Touchable: Double Tap");
    P1Touchable * copied = [self duplicate];
    [self.canvas addSubview:copied];
    [self.canvas setNeedsDisplay];
}

- (void) panCorners1:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Corner 1");
}

- (void) panCorners2:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Corner 2");        
}

- (void) panCorners3:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Corner 3");
    
    CGPoint translation = [gesture translationInView:self.canvas];
    
    float futureWidth = self.icon.frame.size.width + translation.x;
    float futureHeight = self.icon.frame.size.height + translation.y;
    
    if (futureWidth >= RESIZE_BUTTON_SIZE && futureHeight >= RESIZE_BUTTON_SIZE) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        self.icon.frame = CGRectMake(0, 0, futureWidth, futureHeight);
        
        [self updateLayout];
        
        [CATransaction commit];
    }
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.canvas];
}

- (void) panCorners4:(UIPanGestureRecognizer *)gesture
{

}

- (void) updateLayout
{
    //[CATransaction begin];
    //[CATransaction setDisableActions:YES];
    
    self.icon.backgroundColor = [P1Utils myColor:@"green"];//[UIColor orangeColor];
    //self.backgroundColor = [UIColor orangeColor];
    //self.connector.backgroundColor = [UIColor yellowColor];
    
    float newWidth = self.icon.frame.size.width + self.connector.frame.size.width;
    float newHeight = self.icon.frame.size.height;
    
    self.bounds = CGRectMake(0, 0, newWidth, newHeight);
    
    self.connector.center = CGPointMake(self.icon.frame.size.width + self.connector.frame.size.width/2, self.icon.center.y);
    
    //[CATransaction commit];
    
    [self updateCorners];
    [self.icon setNeedsDisplay];
    [self setNeedsDisplay];
    [self.canvas setNeedsDisplay];
}

- (P1Touchable *)duplicate
{
    P1IconView* icon = [[P1IconView alloc] initWithFrame:self.icon.frame withType:@"touchable" withColor:[P1Utils myColor:@"green"]];
    
    P1IconView* connector = [[P1IconView alloc] initWithFrame:self.connector.frame withType:@"trigger"];
    
    P1Touchable* copiedTouchable = [[P1Touchable alloc] initWithFrame:CGRectMake(self.frame.origin.x + 100, self.frame.origin.y, self.frame.size.width, self.frame.size.height) withObjectType:INPUT withIcon:icon withConnector:connector withCanvas:self.canvas groupedGestures:NO];
    
    [copiedTouchable setup];
    
    return copiedTouchable;
}

- (void)drawRect:(CGRect)rect
{
    if (editable) {
        NSLog(@"Editable");
        //[self.corner1 setHidden:false];
        //[self.corner2 setHidden:false];
        [self.corner3 setHidden:false];
        //[self.corner4 setHidden:false];
    } else {
        NSLog(@"Not Editable");
        //[self.corner1 setHidden:true];
        //[self.corner2 setHidden:true];
        [self.corner3 setHidden:true];
        //[self.corner4 setHidden:true];
    }
}

@end
