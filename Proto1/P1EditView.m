//
//  P1EditView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1EditView.h"
#import "P1InputObjectView.h"
#import "P1OutputObjectView.h"

@interface P1EditView()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) BOOL drawPossibilities;
@property (nonatomic, weak) P1InputObjectView* current;

@end

@implementation P1EditView

@synthesize startPoint;
@synthesize endPoint;
@synthesize drawPossibilities;
@synthesize current = _current;

- (void)panIcon:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        CGPoint translation = [gesture translationInView:self];
        
        gesture.view.superview.center = CGPointMake(gesture.view.superview.center.x + translation.x, 
                                            gesture.view.superview.center.y + translation.y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        [self setNeedsDisplay];
    }
}

- (void)panIconMultiple:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        CGPoint translation = [gesture translationInView:self];
        
        gesture.view.superview.superview.center = CGPointMake(gesture.view.superview.superview.center.x + translation.x, 
                                                    gesture.view.superview.superview.center.y + translation.y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        [self setNeedsDisplay];
    }
}

- (void) panConnector:(UIPanGestureRecognizer *)gesture
{
    //NSLog(@"connector panned");
    if ((gesture.state == UIGestureRecognizerStateChanged)) {
        
        self.startPoint = [gesture.view.superview convertPoint:gesture.view.center toView:self];//[self convertPoint:gesture.view.center fromView:gesture.view];
        CGPoint location = [gesture locationInView:self];
        self.endPoint = location;
        
        
        
    } else if(gesture.state == UIGestureRecognizerStateBegan){
        NSLog(@"Began");
        self.drawPossibilities = YES;
        self.current = (P1InputObjectView *) gesture.view.superview;
    } else if ((gesture.state == UIGestureRecognizerStateEnded)){
        UIView* pickedView = [self hitTest:endPoint withEvent:nil];
        if(pickedView != self) {
            if ([pickedView isMemberOfClass:[P1IconView class]]) {
                //pickedView.backgroundColor = [UIColor orangeColor];
                //pickedView.superview.backgroundColor = [UIColor greenColor];
                P1InputObjectView * castedView = (P1InputObjectView *) gesture.view.superview;
                castedView.connectedTo = (P1InputObjectView *)pickedView.superview;
            }
        }
        self.startPoint = CGPointMake(-5, -5);
        self.endPoint = CGPointMake(-5, -5);
        self.drawPossibilities = NO;
        self.current = nil;
    }
    [self setNeedsDisplay];
}

- (void) tapIcon:(UITapGestureRecognizer *)gesture
{
    [gesture.view.superview removeFromSuperview];
    [self setNeedsDisplay];
}

- (void) tapIconMultiple:(UITapGestureRecognizer *)gesture
{
    [gesture.view.superview.superview removeFromSuperview];
    [self setNeedsDisplay];
}

- (void) tapConnector:(UITapGestureRecognizer *)gesture
{
    P1InputObjectView * obj = (P1InputObjectView *) gesture.view.superview;
    obj.hasToBeDrawn = YES;
    obj.connectedTo.hasToBeDrawn = YES;
    obj.connectedTo.connectedTo = nil;
    obj.connectedTo = nil;
    NSLog(@"detectou double tap no connector");
    [self setNeedsDisplay];
}

- (void) swipeConnection:(UISwipeGestureRecognizer *)gesture
{
   
}

- (void)setup
{
    self.drawPossibilities = NO;
    UISwipeGestureRecognizer * sg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeConnection:)];
    [self addGestureRecognizer:sg];
    self.startPoint = CGPointMake(-5, -5);
}

- (void) awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
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

- (void)drawConnectionFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor *)myColor inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [myColor setStroke];
    UIBezierPath *pathToDraw = [UIBezierPath bezierPath];
    [pathToDraw moveToPoint:point1];
    [pathToDraw addLineToPoint:point2];
    [pathToDraw setLineWidth:5.0];
    [pathToDraw stroke];
}

- (void)drawConnectionFrom:(CGPoint)p1 cPoint1:(CGPoint)p2 cPoint2:(CGPoint)p3 endPoint:(CGPoint)p4 withColor:(UIColor *)myColor inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [myColor setStroke];
    UIBezierPath *pathToDraw = [UIBezierPath bezierPath];
    [pathToDraw moveToPoint:p1];
    [pathToDraw addCurveToPoint:p4 controlPoint1:p2 controlPoint2:p3];
    //[pathToDraw addLineToPoint:p4];
    [pathToDraw setLineWidth:5.0];
    [pathToDraw stroke];
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

-(NSArray*)getAllObjects
{
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    for(UIView * currentView in self.subviews){
        if ([currentView isMemberOfClass:[P1InputObjectView class]]) {
            [tempArray addObject:currentView];
        } else if([currentView isMemberOfClass:[P1OutputObjectView class]]){
            for(UIView *subCurrentView in currentView.subviews){
                if ([subCurrentView isMemberOfClass:[P1InputObjectView class]]) {
                    [tempArray addObject:subCurrentView];
                }
            }
        }
    }
    return [NSArray arrayWithArray:tempArray];
}

- (void)drawRect:(CGRect)rect
{
    
    UIColor *connectorColor = [UIColor colorWithRed:0.427 green:0.031 blue:0.224 alpha:100];
    UIColor *strongOrange = [UIColor colorWithRed:0.98 green:0.412 blue:0 alpha:100];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //self.current.backgroundColor = [UIColor greenColor];
    
    [self drawConnectionFrom:self.startPoint to:self.endPoint withColor:connectorColor inContext:context];
    [self drawCircleAtPoint:self.startPoint withRadius:4 withColor:connectorColor inContext:context];
    
    NSArray *allTheSubViews = [self getAllObjects];
    for(UIView * currentView in allTheSubViews){
        if([currentView isMemberOfClass:[P1InputObjectView class]]){
            P1InputObjectView * castedView = (P1InputObjectView *) currentView;
            P1InputObjectView * connectedView = castedView.connectedTo;
            
            CGPoint p1 = [self convertPoint:castedView.connector.center fromView:castedView];
            CGPoint p2 = [self convertPoint:connectedView.connector.center fromView:connectedView];
            CGPoint cp1 = [self convertPoint:castedView.auxPoint fromView:castedView.superview];
            CGPoint cp2 = [self convertPoint:connectedView.auxPoint fromView:connectedView.superview];
            
            //castedView.connector.frame = [castedView.connector convertRect:CGRectMake(100, 0, 50, 100) fromView:castedView];
            
            if (self.current &&
                !self.current.connectedTo &&
                !connectedView){
                if(![castedView.objectType isEqualToString:self.current.objectType]){
                    if(([castedView.connectorType isEqualToString:self.current.connectorType])) {
                        [self drawCircleAtPoint:p1 withRadius:10 withColor:strongOrange inContext:context];
                    } else {
                        //[self drawCircleAtPoint:p1 withRadius:4 withColor:[UIColor redColor] inContext:context];
                    }
                }
            }
            
            if(connectedView && castedView.hasToBeDrawn){
                [self drawCircleAtPoint:p1 withRadius:4 withColor:connectorColor inContext:context];
                [self drawCircleAtPoint:p2 withRadius:4 withColor:connectorColor inContext:context];
                //[self drawConnectionFrom:p1 to:p2 inContext:UIGraphicsGetCurrentContext()];
                [self drawConnectionFrom:p1 cPoint1:cp1 cPoint2:cp2 endPoint:p2 withColor:connectorColor inContext:context];
                connectedView.hasToBeDrawn = YES;
                //[self drawCircleAtPoint:castedView.auxPoint withRadius:3 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
            }
            
            
            
        }
    }
}

@end
