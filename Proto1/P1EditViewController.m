//
//  P1EditViewController.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "P1EditViewController.h"
#import "TestFlight.h"
#import "P1InputObjectView.h"
#import "P1AddObjectMenuViewController.h"
#import "P1PlayViewController.h"
#import "P1ContextMenuViewController.h"
#import "P1OutputObjectView.h"
#import "P1ObjectFactory.h"
#import "P1Utils.h"
#import "P1Touchable.h"
#import <QuartzCore/QuartzCore.h>

@interface P1EditViewController ()

@property (nonatomic, strong) UIPopoverController *myPopover;
@property (nonatomic, strong) UIPopoverController *contextMenuPopover;
@property (nonatomic, strong) UIView* currentManipulatedObject;
@property (nonatomic, assign) BOOL isLeftMenuHidden;
@property (nonatomic, assign) BOOL isRightMenuHidden;


@end

@implementation P1EditViewController
@synthesize rightSideMenuButton;
@synthesize sideMenuButton;
@synthesize botao;
@synthesize contextMenuButton;
@synthesize rightButton;
@synthesize canvas;
@synthesize sideMenu;
@synthesize rightSideMenu;
@synthesize touchable;
@synthesize swipeUp;
@synthesize swipeDown;
@synthesize swipeRight;
@synthesize swipeLeft;
@synthesize swipeDoubleUp;
@synthesize swipeDoubleDown;
@synthesize swipeDoubleRight;
@synthesize swipeDoubleLeft;
@synthesize notesArray;
@synthesize samplesPlayer;
@synthesize afrobeatMachine;
@synthesize teste;
@synthesize magicAreaRight;
@synthesize bin;
@synthesize myPopover = _myPopover;
@synthesize contextMenuPopover = _contextMenuPopover;
@synthesize isLeftMenuHidden = _isLeftMenuHidden;
@synthesize isRightMenuHidden = _isRightMenuHidden;
@synthesize currentManipulatedObject = _currentManipulatedObject;



//======== METHODS FOR REMOTE ACCESS ========
- (IBAction)rightSideMenuButtonAction:(id)sender {
    [self performRightMenuAction];
}

- (IBAction)sideMenuButtonAction:(id)sender {
    [self performLeftMenuAction];
}

- (void) performRightMenuAction
{
    if (self.isRightMenuHidden) {
        [self showRightSideMenu];

    } else {
        [self hideRightSideMenu];

    }
}

- (void)performLeftMenuAction
{
    if (self.isLeftMenuHidden) {
        [self showLeftSideMenu];
    } else {
        [self hideLeftSideMenu];
    }
}

- (void) showRightSideMenu
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.rightSideMenu.center = CGPointMake(self.rightSideMenu.center.x - 110, self.rightSideMenu.center.y);
    self.rightSideMenuButton.center = CGPointMake(self.rightSideMenuButton.center.x - 110, self.rightSideMenuButton.center.y);    
    self.magicAreaRight.center = CGPointMake(self.magicAreaRight.center.x - 110, self.magicAreaRight.center.y);
    self.isRightMenuHidden = NO;
    [UIView commitAnimations];
    NSLog(@"Show Right Menu");
    [TestFlight passCheckpoint:@"Show Right Menu"];
}


- (void) hideRightSideMenu
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.rightSideMenu.center = CGPointMake(self.rightSideMenu.center.x + 110, self.rightSideMenu.center.y);    
    self.rightSideMenuButton.center = CGPointMake(self.rightSideMenuButton.center.x + 110, self.rightSideMenuButton.center.y);
    self.magicAreaRight.center = CGPointMake(self.magicAreaRight.center.x + 110, self.magicAreaRight.center.y);
    self.isRightMenuHidden = YES;
    [UIView commitAnimations];
    NSLog(@"Hide Right Menu");
    [TestFlight passCheckpoint:@"Hide Right Menu"];
}

- (void) showLeftSideMenu
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.sideMenu.center = CGPointMake(self.sideMenu.center.x + 110, self.sideMenu.center.y);
    self.sideMenuButton.center = CGPointMake(self.sideMenuButton.center.x + 110, self.sideMenuButton.center.y);       
    self.teste.center = CGPointMake(self.teste.center.x + 110, self.teste.center.y);
    self.isLeftMenuHidden = NO;
    [UIView commitAnimations];
    NSLog(@"Show Left Menu");
    [TestFlight passCheckpoint:@"Show Left Menu"];
}

- (void) hideLeftSideMenu
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.sideMenu.center = CGPointMake(self.sideMenu.center.x - 110, self.sideMenu.center.y);    
    self.sideMenuButton.center = CGPointMake(self.sideMenuButton.center.x - 110, self.sideMenuButton.center.y);
    self.teste.center = CGPointMake(self.teste.center.x - 110, self.teste.center.y);
    self.isLeftMenuHidden = YES;
    [UIView commitAnimations];
    NSLog(@"Hide Left Menu");
    [TestFlight passCheckpoint:@"Hide Left Menu"];
}


- (UIView*) addObject:(NSString *)identifier
{
    UIView *object;
    
    if ([identifier isEqualToString:@"Play Note"] || [identifier isEqualToString:@"notesArray"]) {
        NSLog(@"Add Notes Array");
        [TestFlight passCheckpoint:@"Add Notes Array"];
        object = [P1ObjectFactory createNoteArrayWithCanvas:self.canvas withGestureHandler:self];
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapHandle:)];
//        P1InputObjectView * objectAux = (P1InputObjectView*) object;
//        [objectAux.icon addGestureRecognizer:longPress];
//        
//        [self.canvas.tapGesture requireGestureRecognizerToFail:longPress];

        
    } else if ([identifier isEqualToString:@"Afrobeat"] || [identifier isEqualToString:@"afrobeat"]) {
        NSLog(@"Add Afrobeat Machine");
        [TestFlight passCheckpoint:@"Add Afrobeat Machine"];
        object = [P1ObjectFactory createAfrobeatWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"sample player"]  || [identifier isEqualToString:@"samplePlayer"]) {
        
        NSLog(@"Add Samples Player");
        [TestFlight passCheckpoint:@"Add Samples Player"];
        object = [P1ObjectFactory createSamplePlayerWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"Note Flow"] || [identifier isEqualToString:@"noteFlow"]) {
        NSLog(@"Add Note Flow");
        [TestFlight passCheckpoint:@"Add Note Flow"];
        object = [P1ObjectFactory createNoteFlowWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"touchable"]) {
        NSLog(@"Add Touchable");  
        [TestFlight passCheckpoint:@"Add Touchable"];
        object = [P1ObjectFactory createTouchable:self.canvas];
    } else if ([identifier isEqualToString:@"OSCNoteArray"]) {
        NSLog(@"Add OSC Note Array");  
        [TestFlight passCheckpoint:@"Add OSC Note Array"];
        object = [P1ObjectFactory createOSCNoteArrayWithCanvas:self.canvas withGestureHandler:self];
        
        //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapHandle:)];
        //P1InputObjectView * objectAux = (P1InputObjectView*) object;
        //[objectAux.icon addGestureRecognizer:longPress];
        
        //[self.canvas.tapGesture requireGestureRecognizerToFail:longPress];
        
    } else if ([identifier isEqualToString:@"circleTouchable"]) {
        NSLog(@"Add Circle Touchable");  
        object = [P1ObjectFactory createCircleTouchable:self.canvas];
    } else if ([identifier isEqualToString:@"multipleTouchable"]) {
        NSLog(@"Add Multiple Touchable");  
        [TestFlight passCheckpoint:@"Add Multiple Touchable"];
        object = [P1ObjectFactory createMultipleTouchable:self.canvas];
        
    } else {
        object = [P1ObjectFactory createInputObject:identifier withCanvas:self.canvas];
    }
    
    
    //object.center = botao.center;
    [self.canvas addSubview:object];
    [self.canvas setNeedsDisplay];
    [self.myPopover dismissPopoverAnimated:NO];
    
    //[TestFlight passCheckpoint:@"Object added"];
    
    return object;
}

- (void) configContextMenu:(P1InputObjectView *)objectView withTag:(int)tag
{
    objectView.action.value = tag;
    [objectView setNeedsDisplay];
    [self.contextMenuPopover dismissPopoverAnimated:NO];
}

//======== SEGUES ========
- (IBAction)launchFeedback:(id)sender {
    //[TestFlight openFeedbackView];
    NSLog(@"Open Feedback");
    [TestFlight passCheckpoint:@"Open Feedback"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddInputObject"] || [segue.identifier isEqualToString:@"AddOutputObject"]) {
        NSLog(@"Segue: Add Object");
        [segue.destinationViewController setEditViewController:self];
        
        CGPoint point;
        
        if([sender isMemberOfClass:[UITapGestureRecognizer class]]){
            UITapGestureRecognizer * gesture = (UITapGestureRecognizer *) sender;
            point = [gesture locationInView:self.canvas];
            //NSLog([NSString stringWithFormat:@"%f, %f", point.x, point.y]);
        }
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            //NSLog(@"YEAY");
            UIStoryboardPopoverSegue * seguePopover = (UIStoryboardPopoverSegue *) segue;
            self.myPopover = seguePopover.popoverController;
            botao.center = point;
            [botao setHidden:YES];
            //[segue.destinationViewController setTapLocation:point];
            //[myPopover.popoverController presentPopoverFromRect:CGRectMake(100, 100, 5, 5) inView:self.canvas permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    } else if ([segue.identifier isEqualToString:@"GoingToPlayMode"]) {
       NSLog(@"Segue: Going to Play Mode");
        
        if (!self.isLeftMenuHidden) {
            [self hideLeftSideMenu];
        }
        
        if (!self.isRightMenuHidden) {
            [self hideRightSideMenu];
        }
        
        //TODO Ver isso depois!
        [segue.destinationViewController setPatchesToLoad:[self whichPatchToLoad]];
        NSArray* array = [self.canvas getAllObjects];
//        for (P1InputObjectView* obj in array) {
//            NSMutableArray* array2 = obj.connectedObjects;
//            for (P1InputObjectView* connected in array2) {
//                P1InputObjectView* conne = connected;
//            }
//        }
        [segue.destinationViewController populateArray:array];
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
        [TestFlight passCheckpoint:@"Going to Play Mode"];
        
    } else if ([segue.identifier isEqualToString:@"AddObjectTableView"]) {
        //#################################################################
        NSLog(@"Segue: Add Object Table View");
        [segue.destinationViewController setEditViewController:self];
        
        CGPoint point;
        
        if([sender isMemberOfClass:[UITapGestureRecognizer class]]){
            UITapGestureRecognizer * gesture = (UITapGestureRecognizer *) sender;
            point = [gesture locationInView:self.canvas];
            //NSLog([NSString stringWithFormat:@"%f, %f", point.x, point.y]);
        }
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            //NSLog(@"YEAY");
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
        NSLog(@"Segue: Note Context Menu");
        [TestFlight passCheckpoint:@"Segue: Note Context Menu"];
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

- (NSArray *)whichPatchToLoad
{
        
    NSMutableArray* patchesToLoad = [[NSMutableArray alloc] init];
    
    for (UIView * currentView in self.canvas.subviews) {
        if ([currentView isKindOfClass:[P1OutputObjectView class]]) {
            P1OutputObjectView * outputObject = (P1OutputObjectView *) currentView;
            [patchesToLoad addObject:outputObject.relatedPatch];
        }
    }
    
    return patchesToLoad;
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
    if(gesture.numberOfTouches == 3){
        [self performSegueWithIdentifier: @"AddObjectTableView" sender:gesture];
    } else if (gesture.numberOfTouches == 4){
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
    
    [TestFlight takeOff:@"c5f999f0-40dd-4051-ae31-798779c3f737"];
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(helpButtonAction:)];
    
    UIBarButtonItem *feedbackButton = [[UIBarButtonItem alloc] initWithTitle:@"Feedback" style:UIBarButtonItemStyleBordered target:self action:@selector(launchFeedback:)];
    
    NSArray *myButtons = [[NSArray alloc] initWithObjects:feedbackButton, helpButton, nil];
    
    self.navigationItem.leftBarButtonItems = myButtons;
    
    //self.navigationController 

    self.canvas.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuToAddObject:)];
    self.canvas.tapGesture.numberOfTapsRequired = 1;
    self.canvas.tapGesture.numberOfTouchesRequired = 4;
    self.canvas.tapGesture.delegate = self.canvas;
    [self.canvas addGestureRecognizer:self.canvas.tapGesture];
    
    UITapGestureRecognizer* doubleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuToAddObject:)];
    doubleTouch.numberOfTapsRequired = 1;
    doubleTouch.numberOfTouchesRequired = 3;
    [self.canvas addGestureRecognizer:doubleTouch];
    
    UIPanGestureRecognizer* panToAdd1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd6 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd7 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd8 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd9 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd10 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd11 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    UIPanGestureRecognizer* panToAdd12 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToAdd:)];
    [self.touchable addGestureRecognizer:panToAdd1];
    [self.swipeUp addGestureRecognizer:panToAdd2];
    [self.swipeDown addGestureRecognizer:panToAdd3];
    [self.swipeRight addGestureRecognizer:panToAdd4];
    [self.swipeLeft addGestureRecognizer:panToAdd5];
    [self.swipeDoubleUp addGestureRecognizer:panToAdd6];
    [self.swipeDoubleDown addGestureRecognizer:panToAdd7];
    [self.swipeDoubleRight addGestureRecognizer:panToAdd8];
    [self.swipeDoubleLeft addGestureRecognizer:panToAdd9];
    [self.notesArray addGestureRecognizer:panToAdd10];
    [self.samplesPlayer addGestureRecognizer:panToAdd11];
    [self.afrobeatMachine addGestureRecognizer:panToAdd12];
    
    UISwipeGestureRecognizer* swipeOpenLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOpenLeftMenu:)];
    
    [swipeOpenLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UISwipeGestureRecognizer* swipeCloseLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCloseLeftMenu:)];
    
    [swipeCloseLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UITapGestureRecognizer* tapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftTab:)];
    //============================================================================================/
    UISwipeGestureRecognizer* swipeOpenRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOpenRightMenu:)];
    
    [swipeOpenRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer* swipeCloseRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCloseRightMenu:)];
    
    [swipeCloseRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UITapGestureRecognizer* tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRightTab:)];
    
    [self.teste addGestureRecognizer:swipeOpenLeft];
    [self.teste addGestureRecognizer:swipeCloseLeft];
    [self.teste addGestureRecognizer:tapLeft];
    
    [self.magicAreaRight addGestureRecognizer:tapRight];
    [self.magicAreaRight addGestureRecognizer:swipeOpenRight];
    [self.magicAreaRight addGestureRecognizer:swipeCloseRight];
    
    [self hideRightSideMenu];
    [self hideLeftSideMenu];
    
    [self.canvas.tapGesture requireGestureRecognizerToFail:doubleTouch];
    
    [self.teste setBackgroundColor:[UIColor clearColor]];
    [self.magicAreaRight setBackgroundColor:[UIColor clearColor]];
    [self.canvas moveBinDown];
    
    //self.canvas.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgNoise"]];
    
}

-(void) helpButtonAction:(id)sender
{
    NSLog(@"Help button pressed");
    [TestFlight passCheckpoint:@"Help Button Pressed"];
    if (self.canvas.isHelpPageHidden) {
//        if (self.isLeftMenuHidden) {
//            [self showLeftSideMenu];
//        }
//        if (self.isRightMenuHidden) {
//            [self showRightSideMenu];
//        }
        [self.canvas showHelp];        
    } else {
        [self.canvas hideHelp];
    }
    
}

-(void)tapRightTab:(UITapGestureRecognizer* ) gesture
{
    [self performRightMenuAction];
}

-(void)tapLeftTab:(UITapGestureRecognizer* ) gesture
{
    [self performLeftMenuAction];
}

-(void)swipeOpenLeftMenu:(UIGestureRecognizer* ) gesture
{
    if (self.isLeftMenuHidden) {
        [self showLeftSideMenu];        
    }

    //NSLog(@"swipe open left");
}

-(void)swipeCloseLeftMenu:(UIGestureRecognizer* ) gesture
{
    if (!self.isLeftMenuHidden) {
        [self hideLeftSideMenu];        
    }
    
    //NSLog(@"swipe close left");
}

-(void)swipeOpenRightMenu:(UIGestureRecognizer* ) gesture
{
    if (self.isRightMenuHidden) {
        [self showRightSideMenu];        
    }
    
    //NSLog(@"swipe open right");
}

-(void)swipeCloseRightMenu:(UIGestureRecognizer* ) gesture
{
    if (!self.isRightMenuHidden) {
        [self hideRightSideMenu];        
    }
    
    //NSLog(@"swipe close right");
}

#warning depois unificar isso num método "move" no InputObject
-(void)panToAdd:(UIPanGestureRecognizer *)gesture
{
    UIButton* draggedButton = (UIButton*) gesture.view;
    CGPoint point = [gesture locationInView:self.canvas];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.canvas moveBinUp];
        self.currentManipulatedObject = [self addObject:[draggedButton currentTitle]];
        if ([self.currentManipulatedObject isKindOfClass:[P1Touchable class]]) {
            self.currentManipulatedObject.center = CGPointMake(point.x - 50, point.y - 50);            
        } else {
            self.currentManipulatedObject.center = point;
        }

    } else if (gesture.state == UIGestureRecognizerStateChanged){
        //self.currentManipulatedObject.center = point;
        
        CGPoint translation = [gesture translationInView:self.canvas];
        
        self.currentManipulatedObject.center = 
                CGPointMake(self.currentManipulatedObject.center.x + translation.x, 
                            self.currentManipulatedObject.center.y + translation.y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self.canvas];
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        [self.canvas moveBinDown];
        [self.canvas sendSubviewToBack:self.currentManipulatedObject];
        if ([self.canvas checkCollision:point]) {
            if ([self.currentManipulatedObject isKindOfClass:[P1InputObjectView class]]) {
                [(P1InputObjectView*)self.currentManipulatedObject killMeNow];
            } else {
                [(P1InputObjectView*)[[self.currentManipulatedObject subviews] objectAtIndex:0] killMeNow];
            }

        }
    }
    //NSLog(@"arrastando");
}



- (void)viewDidUnload
{
    [self setCanvas:nil];
    [self setBotao:nil];
    [self setRightButton:nil];
    [self setContextMenuButton:nil];
    [self setSideMenu:nil];
    [self setSideMenuButton:nil];
    [self setRightSideMenuButton:nil];
    [self setRightSideMenu:nil];
    [self setSwipeUp:nil];
    [self setSwipeDown:nil];
    [self setSwipeRight:nil];
    [self setTouchable:nil];
    [self setSwipeLeft:nil];
    [self setSwipeDoubleUp:nil];
    [self setSwipeDoubleDown:nil];
    [self setSwipeDoubleRight:nil];
    [self setSwipeDoubleLeft:nil];
    [self setNotesArray:nil];
    [self setSamplesPlayer:nil];
    [self setAfrobeatMachine:nil];
    [self setNotesArray:nil];
    [self setSamplesPlayer:nil];
    [self setAfrobeatMachine:nil];
    [self setTeste:nil];
    [self setMagicAreaRight:nil];
    [self setBin:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
