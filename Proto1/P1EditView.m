//
//  P1EditView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "P1EditView.h"
#import "P1InputObjectView.h"
#import "P1OutputObjectView.h"
#import "P1Utils.h"
#import "P1MultipleInputObject.h"

@interface P1EditView()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint debugPoint;
@property (nonatomic, assign) BOOL drawPossibilities;
@property (nonatomic, weak) P1InputObjectView* current;
@property (nonatomic, strong) UIImageView* bin;
@property (nonatomic, strong) UIImageView* help;
@property (nonatomic, assign) BOOL isBinVisible;


@end

@implementation P1EditView

@synthesize startPoint;
@synthesize endPoint;
@synthesize drawPossibilities;
@synthesize current = _current;
@synthesize tapGesture = _tapGesture;
@synthesize bin = _bin;
@synthesize help = _help;
@synthesize isHelpPageHidden = _isHelpPageHidden;
@synthesize isBinVisible = _isBinVisible;
@synthesize debugPoint = _debugPoint;

#warning depois unificar isso num método "move" no InputObject
- (void)panIcon:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Beginning Pan Object");
        [TestFlight passCheckpoint:@"Beginning Pan Object"];
        if ([gesture locationInView:self].y > 500) {
            [self moveBinUp];
        }
    } else if ((gesture.state == UIGestureRecognizerStateChanged)) {
        
        CGPoint translation = [gesture translationInView:self];
        
        gesture.view.superview.center = CGPointMake(gesture.view.superview.center.x + translation.x, 
                                                    gesture.view.superview.center.y + translation.y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        if ([gesture locationInView:self].y > 500) {
            [self moveBinUp];
        } else {
            [self moveBinDown];
        }
        [self setNeedsDisplay];        
    } else if ((gesture.state == UIGestureRecognizerStateEnded)) {
        [self moveBinDown];
        if ([self checkCollision:[gesture locationInView:self]]) {
            [(P1InputObjectView*)gesture.view.superview killMeNow];
        }
        [TestFlight passCheckpoint:@"Ended Pan Object"];
        NSLog(@"Ended Pan Object");
        [self setNeedsDisplay];
    }
    
}

#warning depois unificar isso num método "move" no InputObject
- (void)panIconMultiple:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Beginning Pan Multiple Object");
        [TestFlight passCheckpoint:@"Beginning Pan Multiple Object"];
        if ([gesture locationInView:self].y > 500) {
            [self moveBinUp];
        }
    } else if ((gesture.state == UIGestureRecognizerStateChanged)) {
        
        CGPoint translation = [gesture translationInView:self];
        
        gesture.view.superview.superview.center = CGPointMake(gesture.view.superview.superview.center.x + translation.x, 
                                                              gesture.view.superview.superview.center.y + translation.y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        if ([gesture locationInView:self].y > 500) {
            [self moveBinUp];
        } else {
            [self moveBinDown];
        }
        [self setNeedsDisplay];
    } else if ((gesture.state == UIGestureRecognizerStateEnded)) {
        [self moveBinDown];
        if ([self checkCollision:[gesture locationInView:self]]) {
            [(P1InputObjectView*)gesture.view.superview killMeNow];
        }
        NSLog(@"Ended Pan Multiple Object");
        [TestFlight passCheckpoint:@"Ended Pan Multiple Object"];
        [self setNeedsDisplay];
    }
    //self.debugPoint = [gesture locationInView:self];
    //[self setNeedsDisplay];
}

- (BOOL)checkCollision:(CGPoint)point
{
    BOOL result = NO;
    
    //    if (point.x > (self.bin.center.x - self.bin.frame.size.width/2) && 
    //        point.x < (self.bin.center.x + self.bin.frame.size.width/2) && 
    //        point.y > (self.bin.center.y - self.bin.frame.size.height/2))
    //    {
    //        result = YES;
    //    }
    
    if (point.x > 448 && point.x < 576 && point.y > 576) {
        result = YES;
        NSLog(@"Moved object to Bin");
        [TestFlight passCheckpoint:@"Moved object to Bin"];
    }
    
    //    int moreBoundsX = point.x + 50;
    //    int moreBoundsY = point.y + 50;
    //    
    //    if (moreBoundsX > 448 && moreBoundsX < 576 && moreBoundsY > 576)
    //    {
    //        result = YES;
    //    }
    
    return result;
}

- (void) panConnector:(UIPanGestureRecognizer *)gesture
{
    //NSLog(@"connector panned");
    if ((gesture.state == UIGestureRecognizerStateChanged)) {
        
        self.startPoint = [gesture.view.superview convertPoint:gesture.view.center toView:self];//[self convertPoint:gesture.view.center fromView:gesture.view];
        CGPoint location = [gesture locationInView:self];
        self.endPoint = location;
        
        
    } else if(gesture.state == UIGestureRecognizerStateBegan){
        NSLog(@"Beginning Pan Connector");
        [TestFlight passCheckpoint:@"Beginning Pan Connector"];
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
                [TestFlight passCheckpoint:@"Connection added"];
                NSLog(@"Connection Added");
            }
        }
        self.startPoint = CGPointMake(-5, -5);
        self.endPoint = CGPointMake(-5, -5);
        self.drawPossibilities = NO;
        self.current = nil;
        
        NSLog(@"Ended Pan Connector");
        [TestFlight passCheckpoint:@"Ended Pan Connector"];
    }
    [self setNeedsDisplay];
}

- (void) tapIcon:(UITapGestureRecognizer *)gesture
{
    P1InputObjectView* obj = (P1InputObjectView*) gesture.view.superview;
    //    [obj removeConnections];
    //    [gesture.view.superview removeFromSuperview];
    [obj killMeNow];
    NSLog(@"Double Tap Object");
    [TestFlight passCheckpoint:@"Double Tap Object"];
    [self setNeedsDisplay];
}

- (void) tapIconMultiple:(UITapGestureRecognizer *)gesture
{
    //    for (UIView* currentView in gesture.view.superview.superview.subviews) {
    //        if ([currentView isMemberOfClass:[P1InputObjectView class]]) {
    //            P1InputObjectView* obj = (P1InputObjectView*) currentView;
    //            [obj removeConnections];
    //        }
    //    }
    //    [gesture.view.superview.superview removeFromSuperview];
    P1InputObjectView* obj = (P1InputObjectView*) gesture.view.superview;
    [obj killMeNow];
    NSLog(@"Double Tap Multiple Object");
    [TestFlight passCheckpoint:@"Double Tap Multiple Object"];
    [self setNeedsDisplay];
}

- (void) tapConnector:(UITapGestureRecognizer *)gesture
{
    P1InputObjectView * obj = (P1InputObjectView *) gesture.view.superview;
    obj.hasToBeDrawn = YES;
    
    [obj removeConnections];
    
    //obj.connectedTo.hasToBeDrawn = YES;
    //obj.connectedTo.connectedTo = nil;
    //obj.connectedTo = nil;
    
    [self setNeedsDisplay];
    NSLog(@"Double Tap Connector");
    [TestFlight passCheckpoint:@"Double Tap Connector"];
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
    
    self.bin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bin"]];
    [self addSubview:self.bin];
    self.bin.center = CGPointMake(512, 640);
    
    self.help = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help"]]; 
    
    self.help.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapToHideHelp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHelpPage:)];
    [self.help addGestureRecognizer:tapToHideHelp];
    
    [self addSubview:self.help];
    self.help.center = CGPointMake(self.center.x, self.center.y + 20);
    self.help.alpha = 0;
    
    self.isHelpPageHidden = YES;
    self.isBinVisible = YES;
    
    //NSLog(@"Entrou no setup");
}

- (void) showHelp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    self.help.alpha = 1;
    [UIView commitAnimations];
    self.isHelpPageHidden = NO;
}

- (void)hideHelpPage:(UITapGestureRecognizer*)gesture
{
    [self hideHelp];
    NSLog(@"Hide Help by Tap");
    [TestFlight passCheckpoint:@"Hide Help by Tap"];
}

- (void) hideHelp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    self.help.alpha = 0;
    [UIView commitAnimations];
    self.isHelpPageHidden = YES;
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

- (void) moveBinUp
{
    if (!self.isBinVisible) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        self.bin.center = CGPointMake(self.bin.center.x, 640);    
        self.bin.alpha = 1;
        [UIView commitAnimations];
        NSLog(@"Bin Moved Up");
        self.isBinVisible = YES;
    }
    
    
}

- (void) moveBinDown
{
    if (self.isBinVisible) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        self.bin.center = CGPointMake(self.bin.center.x, self.bounds.size.height + 128);    
        self.bin.alpha = 0;
        [UIView commitAnimations];
        NSLog(@"Bin Moved Down");
        self.isBinVisible = NO;
    }
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
            
            if(castedView.objectType !=self.current.objectType){
                if(([castedView.connectorType isEqualToString:self.current.connectorType])) {
                    if (![self.current.connectedObjects containsObject:castedView]) {
                        [P1Utils drawCircleAtPoint:p1 withRadius:10 withColor:strongOrange inContext:context];
                    }
                    
                } 
            }
            
            
            for (P1InputObjectView* connectedView in castedView.connectedObjects) {
                CGPoint p2 = [self convertPoint:connectedView.connector.center fromView:connectedView];
                CGPoint cp2 = [self convertPoint:connectedView.auxPoint fromView:connectedView];
                
                [P1Utils drawCircleAtPoint:p1 withRadius:4 withColor:connectorColor inContext:context];
                [P1Utils drawCircleAtPoint:p2 withRadius:4 withColor:connectorColor inContext:context];
                [P1Utils drawConnectionFrom:p1 cPoint1:cp1 cPoint2:cp2 endPoint:p2 withColor:connectorColor inContext:context];
            }
            
            //[P1Utils drawCircleAtPoint:self.debugPoint withRadius:50 withColor:[UIColor redColor] inContext:context];
            
            
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
