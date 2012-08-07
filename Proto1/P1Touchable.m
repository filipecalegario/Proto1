//
//  P1Touchable.m
//  Proto1
//
//  Created by Filipe Calegario on 06/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1Touchable.h"
#import "P1Utils.h"
#import <QuartzCore/QuartzCore.h>

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
    self = [super initWithFrame:frame withObjectType:@"input" withIconType:@"touchable" withConnectorType:@"trigger" withCanvas:canvas];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    //self.layer.anchorPoint = CGPointMake(0, 0);
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapHandle:)];
    [self.icon addGestureRecognizer:longPress];
    
    self.corner1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.corner1.backgroundColor = [P1Utils myColor:@"brown"];
    
    self.corner2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.corner2.backgroundColor = [P1Utils myColor:@"brown"];
    
    self.corner3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.corner3.backgroundColor = [P1Utils myColor:@"brown"];
    
    self.corner4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.corner4.backgroundColor = [P1Utils myColor:@"brown"];
    
    UIPanGestureRecognizer *panGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners1:)];
    UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners2:)];
    UIPanGestureRecognizer *panGesture3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners3:)];
    UIPanGestureRecognizer *panGesture4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCorners4:)];
    [self.corner1 addGestureRecognizer:panGesture1];
    [self.corner2 addGestureRecognizer:panGesture2];
    [self.corner3 addGestureRecognizer:panGesture3];
    [self.corner4 addGestureRecognizer:panGesture4];
    
    [self updateCorners];
    
    [self addSubview:self.corner1];
    [self addSubview:self.corner2];
    [self addSubview:self.corner3];
    [self addSubview:self.corner4];
}

- (void) updateCorners
{
    self.corner1.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 20, 20);
    self.corner2.frame = CGRectMake(self.icon.frame.origin.x + self.icon.frame.size.width - 20, self.bounds.origin.y, 20, 20);
    self.corner3.frame = CGRectMake(self.icon.frame.origin.x + self.icon.frame.size.width - 20, self.icon.frame.origin.y + self.icon.frame.size.height - 20, 20, 20);
    self.corner4.frame = CGRectMake(self.bounds.origin.x, self.icon.frame.origin.y + self.icon.frame.size.height - 20, 20, 20);
}

- (void) longTapHandle:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        editable = !editable;
        [self setNeedsDisplay];
    }
}

- (void) panCorners1:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Corner 1");
}

- (void) panCorners2:(UIPanGestureRecognizer *)gesture
{
        
}

- (void) panCorners3:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Corner 3");
    CGPoint translation = [gesture translationInView:self.canvas];
    
    self.translationPoint = translation;
    //CGPoint location = [gesture locationInView:self.canvas];
    
    //self.icon.bounds = CGRectMake(self.icon.bounds.origin.x, self.icon.bounds.origin.y, self.icon.bounds.size.width + translation.x, self.icon.bounds.size.height - translation.y);
    
    self.icon.frame = CGRectMake(0, 0, self.icon.bounds.size.width + translation.x, self.icon.bounds.size.height + translation.y);
    
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.canvas];
    [self updateLayout];
}

- (void) panCorners4:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Corner 4");
}

- (void) updateLayout
{
    self.icon.backgroundColor = [P1Utils myColor:@"strongOrange"];
    //self.backgroundColor = [UIColor orangeColor];
    //self.connector.backgroundColor = [UIColor yellowColor];
    
    float newWidth = self.icon.frame.size.width + self.connector.frame.size.width;
    float newHeight = self.icon.frame.size.height;
    //CGPoint newOrigin = self.icon.frame.origin;
    
    self.bounds = CGRectMake(0, 0, newWidth, newHeight);
    
    //NSLog([NSString stringWithFormat:@"%f, %f", self.icon.frame.size.width]);
    
    //self.connector.bounds = CGRectMake(self.icon.bounds.size.width + self.connector.bounds.size.width/2, self.icon.center.y, self.connector.frame.size.width, self.connector.frame.size.height);
    //self.connector.center = CGPointMake(self.connector.center.x + self.translationPoint.x, self.icon.center.y);
    
    self.connector.center = CGPointMake(self.icon.bounds.size.width + self.connector.bounds.size.width/2, self.icon.center.y);
    
    
    [self updateCorners];
    [self.icon setNeedsDisplay];
    [self setNeedsDisplay];
    [self.canvas setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (editable) {
        NSLog(@"Editable");
        [self.corner1 setHidden:false];
        [self.corner2 setHidden:false];
        [self.corner3 setHidden:false];
        [self.corner4 setHidden:false];
    } else {
        NSLog(@"Not Editable");
        [self.corner1 setHidden:true];
        [self.corner2 setHidden:true];
        [self.corner3 setHidden:true];
        [self.corner4 setHidden:true];
    }
    //[P1Utils drawCircleAtPoint:self.translationPoint withRadius:3 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
}

@end
