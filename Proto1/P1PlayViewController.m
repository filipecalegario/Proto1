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

@interface P1PlayViewController ()

@property (nonatomic, strong) NSString *pitchOrientation;
@property (nonatomic, strong) NSString *durationOrientation;
@property (nonatomic, strong) NSString *mainAction;
@property (nonatomic, strong) NSMutableArray *touchableObjects;
@property (nonatomic, strong) NSMutableDictionary *swipeDictionary;
@property (nonatomic, strong) NSString* patchToLoad;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)populateArray:(NSMutableArray *)objectArray
{
    _objectArray = [[NSMutableArray alloc] init];
    for (P1InputObjectView * object in objectArray) {
        [_objectArray addObject:object];
    }
}

- (void)setupForPlayWith
{
    //self.touchableObjects = [[NSMutableArray alloc] init];
    
    //UIPanGestureRecognizer* panOnEverything = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnEverything:)];
    
    //[self.playArea addGestureRecognizer:panOnEverything];
    
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
        //NSLog([NSString stringWithFormat:@"%@, %@, %@ connectedTo %@, %@, %@", currentObject.objectType, currentObject.iconType, currentObject.connectorType, currentObject.connectedTo.objectType, currentObject.connectedTo.iconType, currentObject.connectedTo.connectorType]);
        
        if ([currentObject.connectedTo.iconType isEqualToString:@"playNote"]) {
            if ([currentObject.iconType isEqualToString:@"touchable"]){
                //[self.touchableObjects addObject:currentObject];
                self.mainAction = @"touchable-playNote";
                P1InputObjectView * touchable = currentObject;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
                button.frame = CGRectMake(touchable.frame.origin.x, touchable.frame.origin.y, touchable.icon.frame.size.width, touchable.icon.frame.size.height);
                button.tag = touchable.connectedTo.myTag;
                [button setBackgroundImage:[UIImage imageNamed:touchable.iconType] forState:UIControlStateNormal];
                [button setTitle:touchable.noteLabel.text forState:UIControlStateNormal];
                
                UIPanGestureRecognizer* panOnTheButton = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnTheButtonAction:)];
                
                [button addGestureRecognizer:panOnTheButton];
                
                [self.playArea addSubview:button];
                
            } else if([currentObject.iconType hasPrefix:@"swipe"]){
                UISwipeGestureRecognizer * swipe = [self createSwipe:currentObject];
                float indexacao = swipe.direction*(swipe.numberOfTouchesRequired+1);
                NSNumber * noteToPlay = [NSNumber numberWithInt:currentObject.connectedTo.myTag];
                NSNumber * keyToStore = [NSNumber numberWithInt:indexacao];
                [self.swipeDictionary setObject:noteToPlay forKey:keyToStore];
                //NSLog([NSString stringWithFormat:@"%i, %i", noteToPlay.intValue, keyToStore.intValue]);
                [self.playArea addGestureRecognizer:swipe];
            }
        } else if(currentObject.connectedTo.myTag == 128.0){
            self.patchToLoad = @"afro-beat.pd";
            NSString * messageToSend = currentObject.connectedTo.noteLabel.text;
            
            if ([currentObject.iconType isEqualToString:@"touchable"]){
                
                P1InputObjectView * touchable = currentObject;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
                button.frame = CGRectMake(touchable.frame.origin.x, touchable.frame.origin.y, touchable.icon.frame.size.width, touchable.icon.frame.size.height);
                button.tag = touchable.connectedTo.myTag;
                button.titleLabel.text = messageToSend;
                [button setImage:[UIImage imageNamed:touchable.iconType] forState:UIControlStateNormal];
                
                [self.playArea addSubview:button];
                
            } else if([currentObject.iconType hasPrefix:@"swipe"]){
                UISwipeGestureRecognizer * swipe = [self createSwipe:currentObject];
                float indexacao = swipe.direction*(swipe.numberOfTouchesRequired+1);
                
                NSNumber * keyToStore = [NSNumber numberWithInt:indexacao];
                [self.swipeDictionary setObject:messageToSend forKey:keyToStore];
                
                //NSLog([NSString stringWithFormat:@"%i, %i", noteToPlay.intValue, keyToStore.intValue]);
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
    return swipe;
}

- (void)panOnEverything:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.playArea];
    UIView* pickedView = [self.playArea hitTest:point withEvent:nil];
    NSLog(pickedView.debugDescription);
    if ([pickedView isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton *)pickedView;
        //button.backgroundColor = [UIColor redColor];
        [PdBase sendFloat:button.tag toReceiver:@"midinote"];
        [PdBase sendBangToReceiver:@"noteTrigger"];
    }
}

- (void)panOnTheButtonAction:(UIPanGestureRecognizer *)gesture
{
    UIButton* buttonForAction = (UIButton *)gesture.view;
    //[PdBase sendFloat:buttonForAction.tag toReceiver:@"midinote"];
    //[PdBase sendBangToReceiver:@"noteTrigger"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
     
    //NSArray *swipeKeys = [NSArray arrayWithObjects:@"swipeUp", @"swipeDown", @"swipeLeft", @"swipeRight",@"swipeDoubleUp", @"swipeDoubleDown", @"swipeDoubleLeft", @"swipeDoubleDown", nil];
    
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
    
    NSLog(@"viewDidLoad");
    
    self.patchToLoad = @"proto1.pd";
    
    [self setupForPlayWith];
    
    [self loadPatch:self.patchToLoad];
    
}

- (void) loadPatch:(NSString*)patchName
{
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture
{
    
    if([self.patchToLoad isEqualToString:@"proto1.pd"]){
        NSNumber* indexacao = [NSNumber numberWithInt:gesture.direction * (gesture.numberOfTouches + 1)];
        NSNumber* noteToSend = [self.swipeDictionary objectForKey:indexacao];
        //NSLog([NSString stringWithFormat:@"NOTE TO SEND: %f, %i, %i, %i",noteToSend.floatValue, gesture.direction, gesture.numberOfTouches, indexacao.intValue]);
        [PdBase sendFloat:noteToSend.floatValue toReceiver:@"midinote"];
        [PdBase sendBangToReceiver:@"noteTrigger"];
    } else if([self.patchToLoad isEqualToString:@"afro-beat.pd"]){ 
        NSNumber* indexacao = [NSNumber numberWithInt:gesture.direction * (gesture.numberOfTouches + 1)];
        NSString* messageToSend = [self.swipeDictionary objectForKey:indexacao];
        [PdBase sendBangToReceiver:messageToSend];
    }
}

- (void)aMethod:(UIButton *)sender
{
    NSLog(@"BUTTON TOUCHED");
    if([self.patchToLoad isEqualToString:@"proto1.pd"]){
        [PdBase sendFloat:sender.tag toReceiver:@"midinote"];
        [PdBase sendBangToReceiver:@"noteTrigger"];
    } else if([self.patchToLoad isEqualToString:@"afro-beat.pd"]){ 
        [PdBase sendBangToReceiver:sender.titleLabel.text];
    }
    
    
}

-(float)mapThis:(float)a fromMin:(float)fmin fromMax:(float)fmax toMin:(float)tmin toMax:(float)tmax
{
    float result = 0;
    float deltaFrom = fmax - fmin;
    float deltaTo = tmax - tmin;
    result = (a*deltaTo - fmin*deltaTo + tmin*deltaFrom)/deltaFrom;
    return result;
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

@end
