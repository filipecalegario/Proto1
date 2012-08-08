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
    
    CGRect defaultRect = CGRectMake(0, 0, 150, 100);
    
    if([identifier isEqualToString:@"Touch"]){
        NSLog(@"adding a touch input object");
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"touch" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"Horizontal Slide"]) {
        NSLog(@"adding a horizontal slide input object");     
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"horizontalSlide" withConnectorType:@"track" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"Vertical Slide"]) {
        NSLog(@"adding a vertical slide input object");       
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"verticalSlide" withConnectorType:@"track" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"Note Flow"]) {
        NSLog(@"adding a play notes output object");
        object = [P1ObjectFactory createNoteFlowWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"Touchable"]) {
        NSLog(@"adding a touchable input object");  
        object = [P1ObjectFactory createTouchable:self.canvas];
        
    } else if ([identifier isEqualToString:@"swipeUp"]) {
        NSLog(@"adding a swipeUp input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeUp" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeDown"]) {
        NSLog(@"adding a swipeDown input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDown" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeLeft"]) {
        NSLog(@"adding a swipeLeft input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeLeft" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeRight"]) {
        NSLog(@"adding a swipeRight input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeRight" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeDoubleUp"]) {
        NSLog(@"adding a swipeDoubleUp input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleUp" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeDoubleDown"]) {
        NSLog(@"adding a swipeDoubleDown input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleDown" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeDoubleLeft"]) {
        NSLog(@"adding a swipeDoubleLeft input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleLeft" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"swipeDoubleRight"]) {
        NSLog(@"adding a swipeDoubleRight input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:@"input" withIconType:@"swipeDoubleRight" withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([identifier isEqualToString:@"Play Note"]) {
        NSLog(@"adding a touchable input object");
        object = [P1ObjectFactory createNoteArrayWithCanvas:self.canvas withGestureHandler:self];
        
    } else if ([identifier isEqualToString:@"Afrobeat"]) {
        NSLog(@"Afrobeat");
        object = [P1ObjectFactory createAfrobeatWithCanvas:self.canvas];
        
    } else if ([identifier isEqualToString:@"sample player"]) {
        NSLog(@"Sample Player");
        object = [P1ObjectFactory createSamplePlayerWithCanvas:self.canvas];
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
        
    } else if ([segue.identifier isEqualToString:@"AddObjectTableView"]) {
        
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
    NSLog(@"doubleTap working...");
    [self performSegueWithIdentifier: @"AddOutputObject" sender:gesture];
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
    
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuToAddObject:)];
    tapGest.numberOfTapsRequired = 2;
    tapGest.numberOfTouchesRequired = 1;
    [self.canvas addGestureRecognizer:tapGest];
    
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
