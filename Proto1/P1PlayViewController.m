//
//  P1PlayViewController.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1PlayViewController.h"
#import "P1InputObjectView.h"
#import "P1IconView.h"
#import "P1PlayTouchable.h"
#import <QuartzCore/QuartzCore.h>
#import "P1TouchGestureRecognizer.h"

@interface P1PlayViewController ()

@property (nonatomic, strong) NSString *pitchOrientation;
@property (nonatomic, strong) NSString *durationOrientation;
@property (nonatomic, strong) NSString *mainAction;
@property (nonatomic, strong) NSMutableArray *touchableObjects;
@property (nonatomic, strong) NSMutableDictionary *swipeDictionary;

@property (nonatomic, strong) UIView* currentPannedView;

@end

@implementation P1PlayViewController

@synthesize playArea;
@synthesize objectArray = _objectArray;
@synthesize pitchOrientation;
@synthesize durationOrientation;
@synthesize mainAction;
@synthesize touchableObjects = _touchableObjects;
@synthesize swipeDictionary = _swipeDictionary;
@synthesize patchToLoad = _patchToLoad;
@synthesize currentPannedView = _currentPannedView;


//======== SETUP/INITIALIZATION ========
#pragma mark - Setup and Initialization

- (void)setupForPlayWith
{
    UIPanGestureRecognizer* panOnEverything = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnEverything:)];
    panOnEverything.delegate = self;
    
    [self.playArea addGestureRecognizer:panOnEverything];
    
    //NSArray *objects = self.objectArray;
    if(self.objectArray){
        if (self.objectArray.count == 0) {
            NSLog(@"objectArray vazio");
        } else {
            NSLog(@"objectArray não está vazio");
        }
    } else {
        NSLog(@"objectArray tah nulo");
    }
    
    for (P1InputObjectView *currentObject in self.objectArray) {
        
        if ([currentObject.connectedTo.iconType isEqualToString:@"playNote"]) {
            
            if ([currentObject.iconType isEqualToString:@"touchable"]){
                
                P1InputObjectView * touchable = currentObject;
                
                P1PlayTouchable * playTouchable = [[P1PlayTouchable alloc] initWithFrame:CGRectMake(touchable.frame.origin.x, touchable.frame.origin.y, touchable.icon.frame.size.width, touchable.icon.frame.size.height)];
                playTouchable.value = touchable.connectedTo.myTag;
                playTouchable.action = touchable.noteLabel.text;
                
//                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTouchableAction:)];
//                [playTouchable addGestureRecognizer:tapGesture];
                
                P1TouchGestureRecognizer * touchGesture = [[P1TouchGestureRecognizer alloc] initWithTarget:self action:@selector(playTouchableAction:)];
                [playTouchable addGestureRecognizer:touchGesture];
                
                [self.playArea addSubview:playTouchable];
                
            } else if([currentObject.iconType hasPrefix:@"swipe"]){
                
                UISwipeGestureRecognizer * swipe = [self createSwipe:currentObject];
                
                float indexacao = swipe.direction*(swipe.numberOfTouchesRequired+1);
                
                NSNumber * noteToPlay = [NSNumber numberWithInt:currentObject.connectedTo.myTag];
                NSNumber * keyToStore = [NSNumber numberWithInt:indexacao];
                
                [self.swipeDictionary setObject:noteToPlay forKey:keyToStore];
                
                [self.playArea addGestureRecognizer:swipe];
                
            }
            
        } else if(currentObject.connectedTo.myTag == 128.0){
            #warning Corrigir essa GAMBIARRA tosca de usar o 128 como definidor de ação!!!
            NSString * messageToSend = currentObject.connectedTo.noteLabel.text;
            //NSLog([NSString stringWithFormat:@"Message To Send is: %@", messageToSend]);
            
            if ([currentObject.iconType isEqualToString:@"touchable"]){
                
                P1InputObjectView * touchable = currentObject;
                {
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
//                button.frame = CGRectMake(touchable.frame.origin.x, touchable.frame.origin.y, touchable.icon.frame.size.width, touchable.icon.frame.size.height);
//                button.tag = touchable.connectedTo.myTag;
//                button.titleLabel.text = messageToSend;
//                [button setImage:[UIImage imageNamed:touchable.iconType] forState:UIControlStateNormal];
//                [self.playArea addSubview:button];
                }
                
                P1PlayTouchable * playTouchable = [[P1PlayTouchable alloc] initWithFrame:CGRectMake(touchable.frame.origin.x, touchable.frame.origin.y, touchable.icon.frame.size.width, touchable.icon.frame.size.height)];
                playTouchable.value = touchable.connectedTo.myTag;
                playTouchable.action = messageToSend;//touchable.noteLabel.text;
                
                //UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTouchableAction:)];
                //[playTouchable addGestureRecognizer:tapGesture];
                
                P1TouchGestureRecognizer * touchGesture = [[P1TouchGestureRecognizer alloc] initWithTarget:self action:@selector(playTouchableAction:)];
                [playTouchable addGestureRecognizer:touchGesture];
                
                [self.playArea addSubview:playTouchable];
                
            } else if([currentObject.iconType hasPrefix:@"swipe"]){
                
                UISwipeGestureRecognizer * swipe = [self createSwipe:currentObject];
                
                float indexacao = swipe.direction*(swipe.numberOfTouchesRequired+1);
                
                NSNumber * keyToStore = [NSNumber numberWithInt:indexacao];
                
                [self.swipeDictionary setObject:messageToSend forKey:keyToStore];
                
                [self.playArea addGestureRecognizer:swipe];
            }
            
            
        }
        
        if ([currentObject.iconType isEqualToString:@"touch"]) {
            if ([currentObject.connectedTo.iconType isEqualToString:@"playNotes"]) {
                self.mainAction = @"touch-playNotes";
                
                UIPanGestureRecognizer* panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
                [self.playArea addGestureRecognizer:panIconGesture];
                
            }
        } else if ([currentObject.iconType isEqualToString:@"horizontalSlide"]) {
            if ([currentObject.connectedTo.iconType isEqualToString:@"pitch"]) {
                self.pitchOrientation = @"horizontal";
            } else if ([currentObject.connectedTo.iconType isEqualToString:@"duration"]) {
                self.durationOrientation = @"horizontal";
            }
        } else if ([currentObject.iconType isEqualToString:@"verticalSlide"]) {
            if ([currentObject.connectedTo.iconType isEqualToString:@"pitch"]) {
                self.pitchOrientation = @"vertical";
            } else if ([currentObject.connectedTo.iconType isEqualToString:@"duration"]) {
                self.durationOrientation = @"vertical";
            }
        }
        
    }
    //NSLog(self.mainAction);
}

- (void)populateArray:(NSArray *)objectArray
{
    self.objectArray = objectArray;
}

- (void) initializeSwipeDictionary
{
    NSArray * initialNotes = [NSArray arrayWithObjects: [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:50],
                              nil];
    
    NSArray * swipeKeys = [NSArray arrayWithObjects: 
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionUp*2],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionDown*2],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionLeft*2],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionRight*2],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionUp*(2+1)],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionDown*(2+1)],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionLeft*(2+1)],
                           [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionRight*(2+1)],
                           nil];
    
    self.swipeDictionary = [[NSMutableDictionary alloc] initWithObjects:initialNotes forKeys:swipeKeys];
}

- (UISwipeGestureRecognizer*) createSwipe:(P1InputObjectView*)currentObject
{
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    if ([currentObject.iconType hasSuffix:@"DoubleUp"]){
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
    } else if ([currentObject.iconType hasSuffix:@"DoubleDown"]){
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionDown;                    
    } else if ([currentObject.iconType hasSuffix:@"DoubleLeft"]){
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    } else if ([currentObject.iconType hasSuffix:@"DoubleRight"]){          
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
    } else if ([currentObject.iconType hasSuffix:@"Up"]) {
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
    } else if ([currentObject.iconType hasSuffix:@"Down"]){
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
    } else if ([currentObject.iconType hasSuffix:@"Left"]){
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    } else if ([currentObject.iconType hasSuffix:@"Right"]){
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
    }
    
    swipe.delegate = self;
    return swipe;
}

//======== GESTURES HANDLERS ========
#pragma mark - Gesture Handlers

- (void)aMethod:(UIButton *)sender
{
    NSLog(@"BUTTON TOUCHED");
    if([self.patchToLoad isEqualToString:@"proto1.pd"]){
        [PdBase sendFloat:sender.tag toReceiver:@"midinote"];
        [PdBase sendBangToReceiver:@"noteTrigger"];
    } else if([self.patchToLoad isEqualToString:@"afro-beat.pd"]){ 
        [PdBase sendBangToReceiver:sender.titleLabel.text];
    } else if([self.patchToLoad isEqualToString:@"mySimpleSamplePlayer.pd"]){ 
        [PdBase sendBangToReceiver:sender.titleLabel.text];
    }
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture
{
#warning Deixar isso sem tá dependende do patch!
    
    NSLog(@"Swipe Detected");
    
    if([self.patchToLoad isEqualToString:@"proto1.pd"]){
        NSNumber* indexacao = [NSNumber numberWithInt:gesture.direction * (gesture.numberOfTouches + 1)];
        NSNumber* noteToSend = [self.swipeDictionary objectForKey:indexacao];
        //NSLog([NSString stringWithFormat:@"NOTE TO SEND: %f, %i, %i, %i",noteToSend.floatValue, gesture.direction, gesture.numberOfTouches, indexacao.intValue]);
        [PdBase sendFloat:noteToSend.floatValue toReceiver:@"midinote"];
        [PdBase sendBangToReceiver:@"noteTrigger"];
    } else if([self.patchToLoad isEqualToString:@"afro-beat.pd"] || [self.patchToLoad isEqualToString:@"mySimpleSamplePlayer.pd"]){ 
        NSNumber* indexacao = [NSNumber numberWithInt:gesture.direction * (gesture.numberOfTouches + 1)];
        NSString* messageToSend = [self.swipeDictionary objectForKey:indexacao];
        [PdBase sendBangToReceiver:messageToSend];
    }
}

- (void)playTouchableAction:(UITapGestureRecognizer *)gesture
{
    P1PlayTouchable * playTouchable = (P1PlayTouchable *) gesture.view;
    
    NSLog([NSString stringWithFormat:@"%i", gesture.state]);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"PlayTouchableAction!"); 
        if([self.patchToLoad isEqualToString:@"proto1.pd"]){
            
            //NSLog([NSString stringWithFormat:@"%@, %@", playTouchable.value, playTouchable.action]);
            
            [PdBase sendFloat:playTouchable.value toReceiver:@"midinote"];
            [PdBase sendBangToReceiver:@"noteTrigger"];
        } else if([self.patchToLoad isEqualToString:@"afro-beat.pd"] || [self.patchToLoad isEqualToString:@"mySimpleSamplePlayer.pd"]){ 
            NSLog(playTouchable.action);
            [PdBase sendBangToReceiver:playTouchable.action];
        }
        
    }
       
}

- (void)touch:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
        NSLog(@"Gesture Recognition Began!");
        [PdBase sendBangToReceiver:@"trigger"];
    } else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint location = [gesture locationInView:playArea];
        
        //float horizontalOrientation = [self mapThis:location.x fromMin:0 fromMax:gesture.view.frame.size.width toMin:60 toMax:80];
        //float verticalOrientation = [self mapThis:location.y fromMin:0 fromMax:gesture.view.frame.size.height toMin:100  toMax:500];
        
        float pitch = 0;
        float duration = 0;
        
        if([self.pitchOrientation isEqualToString:@"vertical"]){
            pitch = [self mapThis:location.y fromMin:0 fromMax:gesture.view.frame.size.height toMin:60  toMax:80];
        } else if([self.pitchOrientation isEqualToString:@"horizontal"]) {
            pitch = [self mapThis:location.x fromMin:0 fromMax:gesture.view.frame.size.width toMin:60 toMax:80];
        } else {
            pitch = 50;
        }
        
        if([self.durationOrientation isEqualToString:@"vertical"]){
            duration = [self mapThis:location.y fromMin:0 fromMax:gesture.view.frame.size.height toMin:100  toMax:500];
        } else if([self.durationOrientation isEqualToString:@"horizontal"]) {
            duration = [self mapThis:location.x fromMin:0 fromMax:gesture.view.frame.size.width toMin:100 toMax:500];
        } else {
            duration = 250;
        }
        
        //NSLog([NSString stringWithFormat:@"Pitch: %f Duration: %f", pitch, duration]);
        
        [PdBase sendFloat:pitch toReceiver:@"midinote"];
        [PdBase sendFloat:duration toReceiver:@"metro"];
        playArea.tapPoint = location;
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        [PdBase sendBangToReceiver:@"trigger"];
    }
}

- (void)panOnTheButtonAction:(UIPanGestureRecognizer *)gesture
{
    //UIButton* buttonForAction = (UIButton *)gesture.view;
    //[PdBase sendFloat:buttonForAction.tag toReceiver:@"midinote"];
    //[PdBase sendBangToReceiver:@"noteTrigger"];
}

- (void)panOnEverything:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.playArea];
    UIView* pickedView = [self.playArea hitTest:point withEvent:nil];
    
    if ([pickedView isKindOfClass:[P1PlayTouchable class]]) {
        if (pickedView != self.currentPannedView) {
            P1PlayTouchable * pickedTouchable = (P1PlayTouchable *) pickedView;
            [self playNote:pickedTouchable.value];
            self.currentPannedView = pickedView;
        }
    }
    
    if ([pickedView isKindOfClass:[P1PlayView class]]) {
        self.currentPannedView = self.playArea;
    }
    
    //NSLog(pickedView.debugDescription);
    //    if ([pickedView isKindOfClass:[UIButton class]]) {
    //        UIButton* button = (UIButton *)pickedView;
    //        //button.backgroundColor = [UIColor redColor];
    //        [PdBase sendFloat:button.tag toReceiver:@"midinote"];
    //        [PdBase sendBangToReceiver:@"noteTrigger"];
    //    }
}

//======== GESTURES DELEGATE METHODS ========
#pragma mark - Gesture Delegate Methods

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//======== DEFAULT METHODS ========
#pragma mark - Default Methods

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    [self initializeSwipeDictionary];
    
    [self setupForPlayWith];
    
    [self loadPatch:self.patchToLoad];
    
}

- (void)viewDidUnload
{
    [self setPlayArea:nil];
    [super viewDidUnload];
    //    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
    patch = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//======== SOUND-RELATED METHODS ========
#pragma mark - Sound-related methods

- (void) loadPatch:(NSString*)patchName
{
    NSLog([NSString stringWithFormat:@"Carregando patch: %@", patchName]);
    
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
}

-(void) playNote:(int)note
{
    [PdBase sendFloat:note toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"noteTrigger"];
}

//======== MANDAR PRA UTILS ========
-(float)mapThis:(float)a fromMin:(float)fmin fromMax:(float)fmax toMin:(float)tmin toMax:(float)tmax
{
    float result = 0;
    float deltaFrom = fmax - fmin;
    float deltaTo = tmax - tmin;
    result = (a*deltaTo - fmin*deltaTo + tmin*deltaFrom)/deltaFrom;
    return result;
}

@end

