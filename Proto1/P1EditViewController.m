//
//  P1EditViewController.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1EditViewController.h"

#import "P1InputObjectView.h"
#import "P1AddObjectMenuViewController.h"
#import "P1PlayViewController.h"
#import "P1ContextMenuViewController.h"
#import "P1OutputObjectView.h"
#import "P1ObjectFactory.h"
#import "P1Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface P1EditViewController ()

@property (nonatomic, strong) UIPopoverController *myPopover;
@property (nonatomic, strong) UIPopoverController *contextMenuPopover;

@end

@implementation P1EditViewController
@synthesize botao;
@synthesize contextMenuButton;
@synthesize rightButton;
@synthesize canvas;
@synthesize myPopover = _myPopover;
@synthesize contextMenuPopover = _contextMenuPopover;



//======== METHODS FOR REMOTE ACCESS ========

- (void) addObject:(NSString *)identifier
{
    UIView *object;
    
    //    CGRect defaultRect = CGRectMake(0, 0, 150, 100);
    //    
    //    if([identifier isEqualToString:@"touch"]){
    //        NSLog(@"adding a touch input object");
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"touch" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"horizontalSlide"]) {
    //        NSLog(@"adding a horizontal slide input object");     
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"horizontalSlide" withConnectorType:@"track" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"verticalSlide"]) {
    //        NSLog(@"adding a vertical slide input object");       
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"verticalSlide" withConnectorType:@"track" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeUp"]) {
    //        NSLog(@"adding a swipeUp input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeUp" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeDown"]) {
    //        NSLog(@"adding a swipeDown input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDown" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeLeft"]) {
    //        NSLog(@"adding a swipeLeft input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeLeft" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeRight"]) {
    //        NSLog(@"adding a swipeRight input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeRight" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeDoubleUp"]) {
    //        NSLog(@"adding a swipeDoubleUp input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleUp" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeDoubleDown"]) {
    //        NSLog(@"adding a swipeDoubleDown input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleDown" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeDoubleLeft"]) {
    //        NSLog(@"adding a swipeDoubleLeft input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleLeft" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } else if ([identifier isEqualToString:@"swipeDoubleRight"]) {
    //        NSLog(@"adding a swipeDoubleRight input object");  
    //        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleRight" withConnectorType:@"trigger" withCanvas:canvas];
    //        
    //    } 
    // MOVER ATÉ AQUI ============================
    if ([identifier isEqualToString:@"Play Note"] || [identifier isEqualToString:@"notesArray"]) {
        NSLog(@"adding a touchable input object");
        object = [P1ObjectFactory createNoteArrayWithCanvas:self.canvas withGestureHandler:self];
        
    } else if ([identifier isEqualToString:@"Afrobeat"] || [identifier isEqualToString:@"afrobeat"]) {
        NSLog(@"Afrobeat");
        object = [P1ObjectFactory createAfrobeatWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"sample player"]  || [identifier isEqualToString:@"samplePlayer"]) {
        NSLog(@"Sample Player");
        object = [P1ObjectFactory createSamplePlayerWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"Note Flow"] || [identifier isEqualToString:@"noteFlow"]) {
        NSLog(@"adding a play notes output object");
        object = [P1ObjectFactory createNoteFlowWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"touchable"]) {
        NSLog(@"adding a touchable input object");  
        object = [P1ObjectFactory createTouchable:self.canvas];
    } else if ([identifier isEqualToString:@"OSCNoteArray"]) {
        NSLog(@"adding a touchable input object");  
        object = [P1ObjectFactory createOSCNoteArrayWithCanvas:self.canvas withGestureHandler:self];
    } else {
        object = [P1ObjectFactory createInputObject:identifier withCanvas:self.canvas];
    }
    
    
    object.center = botao.center;
    [self.canvas addSubview:object];
    [self.canvas setNeedsDisplay];
    [self.myPopover dismissPopoverAnimated:NO];
}

- (void) configContextMenu:(P1InputObjectView *)objectView withTag:(int)tag
{
    objectView.myTag = tag;
    [objectView setNeedsDisplay];
    [self.contextMenuPopover dismissPopoverAnimated:NO];
}

//======== SEGUES ========

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddInputObject"] || [segue.identifier isEqualToString:@"AddOutputObject"]) {
        NSLog(@"Add gesture segue");
        [segue.destinationViewController setEditViewController:self];
        
        CGPoint point;
        
        if([sender isMemberOfClass:[UITapGestureRecognizer class]]){
            UITapGestureRecognizer * gesture = (UITapGestureRecognizer *) sender;
            point = [gesture locationInView:self.canvas];
            //NSLog([NSString stringWithFormat:@"%f, %f", point.x, point.y]);
        }
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            NSLog(@"YEAY");
            UIStoryboardPopoverSegue * seguePopover = (UIStoryboardPopoverSegue *) segue;
            self.myPopover = seguePopover.popoverController;
            botao.center = point;
            [botao setHidden:YES];
            //[segue.destinationViewController setTapLocation:point];
            //[myPopover.popoverController presentPopoverFromRect:CGRectMake(100, 100, 5, 5) inView:self.canvas permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    } else if ([segue.identifier isEqualToString:@"GoingToPlayMode"]) {
        NSLog(@"Going to play segue");
        
        //TODO Ver isso depois!
        [segue.destinationViewController setPatchToLoad:[self whichPatchToLoad]];
        [segue.destinationViewController populateArray:[self.canvas getAllObjects]];
        [segue.destinationViewController setBackgroundForPlayArea:[P1Utils imageWithView:self.canvas]];
        
        
//        CATransition *transition = [CATransition animation];
//        transition.duration =  0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromTop;
//        //transitioning = YES;
//        transition.delegate = self;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController pushViewController:segue.destinationViewController animated:YES];
        
    } else if ([segue.identifier isEqualToString:@"AddObjectTableView"]) {
        //#################################################################
        
        [segue.destinationViewController setEditViewController:self];
        
        CGPoint point;
        
        if([sender isMemberOfClass:[UITapGestureRecognizer class]]){
            UITapGestureRecognizer * gesture = (UITapGestureRecognizer *) sender;
            point = [gesture locationInView:self.canvas];
            //NSLog([NSString stringWithFormat:@"%f, %f", point.x, point.y]);
        }
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            NSLog(@"YEAY");
            UIStoryboardPopoverSegue * seguePopover = (UIStoryboardPopoverSegue *) segue;
            self.myPopover = seguePopover.popoverController;
            rightButton.center = point;
            self.botao.center = point;
            [rightButton setHidden:YES];
            //[segue.destinationViewController setTapLocation:point];
            //[myPopover.popoverController presentPopoverFromRect:CGRectMake(100, 100, 5, 5) inView:self.canvas permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
        //#################################################################        
    } else if ([segue.identifier isEqualToString:@"ContextMenu"]) {
        
        [segue.destinationViewController setEditController:self];
        
        CGPoint point;
        
        if([sender isMemberOfClass:[P1InputObjectView class]]){
            P1InputObjectView * objectView = (P1InputObjectView *) sender;
            point = [self.canvas convertPoint:objectView.center fromView:objectView.superview];
            [segue.destinationViewController setObjectView:objectView];
            //NSLog([NSString stringWithFormat:@"%f, %f", point.x, point.y]);
        }
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue * seguePopover = (UIStoryboardPopoverSegue *) segue;
            self.contextMenuPopover = seguePopover.popoverController;
            contextMenuButton.center = point;
            [contextMenuButton setHidden:YES];
        }
    }
}

- (NSString *)whichPatchToLoad
{
    /*WARNING cuidado com este método. Problemas com múltiplos objetos de saída.
     Pode carregar o patch diferente.
     */
    
#warning Cuidado com esse método!
    
    NSString * patchToLoad = @"";
    
    for (UIView * currentView in self.canvas.subviews) {
        if ([currentView isKindOfClass:[P1OutputObjectView class]]) {
            P1OutputObjectView * outputObject = (P1OutputObjectView *) currentView;
            patchToLoad = outputObject.relatedPatch;
        }
    }
    
    return patchToLoad;
}

//======== GESTURES HANDLERS ========
#pragma mark - Gesture Handlers

- (void) longTapHandle:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:@"ContextMenu" sender:gesture.view.superview];
    }
}

- (void) openMenuToAddObject:(UITapGestureRecognizer *)gesture
{
    if(gesture.numberOfTouches == 1){
        [self performSegueWithIdentifier: @"AddObjectTableView" sender:gesture];
    } else if (gesture.numberOfTouches == 3){
        [self performSegueWithIdentifier: @"AddOutputObject" sender:gesture];
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

//======== DEFAULT METHODS ========

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationController 

    self.canvas.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuToAddObject:)];
    self.canvas.tapGesture.numberOfTapsRequired = 1;
    self.canvas.tapGesture.numberOfTouchesRequired = 1;
    self.canvas.tapGesture.delegate = self.canvas;
    [self.canvas addGestureRecognizer:self.canvas.tapGesture];
    
    UITapGestureRecognizer* doubleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuToAddObject:)];
    doubleTouch.numberOfTapsRequired = 1;
    doubleTouch.numberOfTouchesRequired = 3;
    [self.canvas addGestureRecognizer:doubleTouch];
    
    [self.canvas.tapGesture requireGestureRecognizerToFail:doubleTouch];
    
}

- (void)viewDidUnload
{
    [self setCanvas:nil];
    [self setBotao:nil];
    [self setRightButton:nil];
    [self setContextMenuButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
