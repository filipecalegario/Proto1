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
#import "P1Utils.h"
#import "P1MultipleInputObject.h"

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
@synthesize tapGesture = _tapGesture;

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
                [castedView connectObject:((P1InputObjectView *)pickedView.superview)];
            }
        }
        self.startPoint = CGPointMake(-5, -5);
        self.endPoint = CGPointMake(-5, -5);
        self.drawPossibilities = NO;
        self.current = nil;
        [TestFlight passCheckpoint:@"Connection added"];
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
    
    for (P1InputObjectView* connectedTo in obj.connectedObjects) {
        [connectedTo.connectedObjects removeObject:obj];
    }
    [obj.connectedObjects removeAllObjects];
    
    //obj.connectedTo.hasToBeDrawn = YES;
    //obj.connectedTo.connectedTo = nil;
    //obj.connectedTo = nil;
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

-(NSArray*)getAllObjects
{
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    for(UIView * currentView in self.subviews){
        if ([currentView isKindOfClass:[P1InputObjectView class]]) {
            [tempArray addObject:currentView];
        } else if([currentView isKindOfClass:[P1OutputObjectView class]] || [currentView isKindOfClass:[P1MultipleInputObject class]]){
            for(UIView *subCurrentView in currentView.subviews){
                if ([subCurrentView isKindOfClass:[P1InputObjectView class]]) {
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
    
    [P1Utils drawConnectionFrom:self.startPoint to:self.endPoint withColor:connectorColor inContext:context];
    [P1Utils drawCircleAtPoint:self.startPoint withRadius:4 withColor:connectorColor inContext:context];
    
    NSArray *allTheSubViews = [self getAllObjects];
    for(UIView * currentView in allTheSubViews){
        if([currentView isKindOfClass:[P1InputObjectView class]]){
            
            P1InputObjectView * castedView = (P1InputObjectView *) currentView;
            CGPoint p1 = [self convertPoint:castedView.connector.center fromView:castedView];            
            CGPoint cp1 = [self convertPoint:castedView.auxPoint fromView:castedView];
            
            for (P1InputObjectView* connectedView in castedView.connectedObjects) {
                CGPoint p2 = [self convertPoint:connectedView.connector.center fromView:connectedView];
                CGPoint cp2 = [self convertPoint:connectedView.auxPoint fromView:connectedView];
                
                [P1Utils drawCircleAtPoint:p1 withRadius:4 withColor:connectorColor inContext:context];
                [P1Utils drawCircleAtPoint:p2 withRadius:4 withColor:connectorColor inContext:context];
                [P1Utils drawConnectionFrom:p1 cPoint1:cp1 cPoint2:cp2 endPoint:p2 withColor:connectorColor inContext:context];
            }
            
            
            if(castedView.objectType !=self.current.objectType){
                
                if(([castedView.connectorType isEqualToString:self.current.connectorType])) {
                    [P1Utils drawCircleAtPoint:p1 withRadius:10 withColor:strongOrange inContext:context];
                } 
            }
            
            
            
            //            P1InputObjectView * castedView = (P1InputObjectView *) currentView;
            //            P1InputObjectView * connectedView = castedView.connectedTo;
            //            
            //            CGPoint p1 = [self convertPoint:castedView.connector.center fromView:castedView];
            //            CGPoint p2 = [self convertPoint:connectedView.connector.center fromView:connectedView];
            //            CGPoint cp1 = [self convertPoint:castedView.auxPoint fromView:castedView];
            //            CGPoint cp2 = [self convertPoint:connectedView.auxPoint fromView:connectedView];
            //            
            //            if (self.current && !self.current.connectedTo && !connectedView){
            //                
            //                if(castedView.objectType !=self.current.objectType){
            //                    
            //                    if(([castedView.connectorType isEqualToString:self.current.connectorType])) {
            //                        [P1Utils drawCircleAtPoint:p1 withRadius:10 withColor:strongOrange inContext:context];
            //                    } 
            //                }
            //            }
            //            
            //            if(connectedView && castedView.hasToBeDrawn){
            //                [P1Utils drawCircleAtPoint:p1 withRadius:4 withColor:connectorColor inContext:context];
            //                [P1Utils drawCircleAtPoint:p2 withRadius:4 withColor:connectorColor inContext:context];
            //                [P1Utils drawConnectionFrom:p1 cPoint1:cp1 cPoint2:cp2 endPoint:p2 withColor:connectorColor inContext:context];
            //                connectedView.hasToBeDrawn = YES;
            //            }
            //            
            //            //[P1Utils drawCircleAtPoint:cp1 withRadius:4 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
            //            //[P1Utils drawCircleAtPoint:cp2 withRadius:4 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
            //            
            //            
            //            //CGPoint centerOwn = castedView.center;
            //            //CGPoint auxPoint = CGPointMake(centerOwn.x + 200, centerOwn.y);
            //            //[P1Utils drawCircleAtPoint:centerOwn withRadius:10 withColor:[UIColor blueColor] inContext:UIGraphicsGetCurrentContext()];
            //            //[P1Utils drawCircleAtPoint:auxPoint withRadius:10 withColor:[UIColor greenColor] inContext:UIGraphicsGetCurrentContext()];
            
        }
    }
}

//======== GESTURES DELEGATE METHODS ========
#pragma mark - Gesture Delegate Methods

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
