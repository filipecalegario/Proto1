//
//  P1InputObjectView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1InputObjectView.h"
#import "P1Utils.h"

@interface P1InputObjectView()

@property (nonatomic, strong) NSString * connectorState;

@end

@implementation P1InputObjectView

@synthesize canvas = _canvas;
@synthesize icon = _icon;
@synthesize connector = _connector;
@synthesize objectType = _objectType;
@synthesize iconType = _iconType;
@synthesize connectorType = _connectorType;
//@synthesize connectedTo = _connectedTo;
@synthesize hasToBeDrawn = _hasToBeDrawn;
//@synthesize myTag = _myTag;
@synthesize label = _label;
@synthesize auxPoint = _auxPoint;
@synthesize connectorState = _connectorState;
//@synthesize name = _name;
//@synthesize value = _value;
@synthesize connectedObjects = _connectedObjects;
@synthesize action = _action;

- (void) connectObject:(P1InputObjectView *)connectedTo
{
//    if(connectedTo != self && _connectedTo == nil){
//        if ((connectedTo.objectType != _objectType) &&[connectedTo.connectorType isEqualToString:_connectorType]) {
//            if(connectedTo.connectedTo == nil || connectedTo.connectedTo == self){
//                _connectedTo = connectedTo;
//                if (connectedTo.connectedTo == nil) {
//                    _connectedTo.connectedTo = self;
//                }
//            }
//        }
//    } else if (!connectedTo){
//        _connectedTo = nil;
//    }
    if ((connectedTo.objectType != _objectType) &&[connectedTo.connectorType isEqualToString:_connectorType]) {
//        __weak P1InputObjectView* addConnectedTo = connectedTo;
//        __weak P1InputObjectView* addSelf = self;
//        [self.connectedObjects addObject:addConnectedTo];
//        [connectedTo.connectedObjects addObject:addSelf];
        
//        NSValue *valueConnectedTo = [NSValue valueWithNonretainedObject:connectedTo];
//        NSValue *valueSelf = [NSValue valueWithNonretainedObject:self];
//        [self.connectedObjects addObject:valueConnectedTo];
//        [connectedTo.connectedObjects addObject:valueSelf];
        
        if (![self.connectedObjects containsObject:connectedTo] && ![connectedTo.connectedObjects containsObject:self]) {
            [self.connectedObjects addObject:connectedTo];
            [connectedTo.connectedObjects addObject:self];
        }
        
        
    }
}

- (CGPoint)auxPoint
{
    CGFloat distance = 100;
    
    CGPoint auxPoint;
    
    switch (self.objectType) {
        case INPUT:
            auxPoint = CGPointMake(self.connector.center.x + distance, self.connector.center.y);
            break;
        case OUTPUT:
            auxPoint = CGPointMake(self.connector.center.x - distance, self.connector.center.y);
            break;
        default:
            break;
    }
    
//    if(self.objectType == INPUT){
//        auxPoint = CGPointMake(self.connector.center.x + distance, self.connector.center.y);
//    } else if(self.objectType == OUTPUT){
//        auxPoint = CGPointMake(self.connector.center.x - distance, self.connector.center.y);
//    }

    return auxPoint;
}

- (void)setup:(ObjectType)objectType withIconType:(NSString *)iconType withConnectorType:(NSString *)connectorType withCanvas:(P1EditView *)canvas
{

    self.canvas = canvas;
    self.hasToBeDrawn = true;
    
    self.iconType = iconType;
    self.connectorType = connectorType;
    self.objectType = objectType;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    
    
    switch (self.objectType) {
        case INPUT:
            self.icon = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withType:iconType];
            self.connector = [[P1IconView alloc] initWithFrame:CGRectMake(100, 0, 50, 100) withType:connectorType];
            break;
        case OUTPUT:
            self.connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 100) withType:[NSString stringWithFormat:@"%@Flipped", connectorType]];
            self.icon = [[P1IconView alloc] initWithFrame:CGRectMake(50, 0, 100, 100) withType:iconType];
            break;
        default:
            break;
    }
    
    
//    if([self.objectType isEqualToString:@"input"]){
//        self.icon = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withType:iconType];
//        self.connector = [[P1IconView alloc] initWithFrame:CGRectMake(100, 0, 50, 100) withType:connectorType];
//    } else if([self.objectType isEqualToString:@"output"]){
//        self.connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 100) withType:[NSString stringWithFormat:@"%@Flipped", connectorType]];
//        self.icon = [[P1IconView alloc] initWithFrame:CGRectMake(50, 0, 100, 100) withType:iconType];
//    }
    
    [self setupDefaultGestures:NO];
    
//    UIPanGestureRecognizer* panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panIcon:)];
//    UIPanGestureRecognizer* panConnectorGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panConnector:)];
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapIcon:)];
//    tapGesture.numberOfTouchesRequired = 1;
//    tapGesture.numberOfTapsRequired = 2;
//    
//    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapConnector:)];
//    tapGesture2.numberOfTouchesRequired = 1;
//    tapGesture2.numberOfTapsRequired = 2;
//    
//    [_icon addGestureRecognizer:tapGesture];
//    [_icon addGestureRecognizer:panIconGesture];
//    [_connector addGestureRecognizer:panConnectorGesture];
//    [_connector addGestureRecognizer:tapGesture2];
    
    [self addSubview:_icon];
    [self addSubview:_connector];
    
    if ([self.iconType isEqualToString:@"playNote"]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 25, 25)];
        self.label.text = [NSString stringWithFormat:@"%i", self.action.value];
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:[P1Utils defaultFont] size:18];
        [self addSubview:self.label];
    }
}

- (id)initWithFrame:(CGRect)frame withObjectType:(ObjectType)objectType withIcon:(P1IconView*)iconObject withConnector:(P1IconView*)connectorObject withCanvas:(P1EditView*)canvas groupedGestures:(BOOL)grouped
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialConfiguration];
        self.canvas = canvas;
        self.hasToBeDrawn = true;
        
        self.iconType = iconObject.type;
        self.connectorType = connectorObject.type;
        self.objectType = objectType;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.icon = iconObject;
        self.connector = connectorObject;
        
        [self setupDefaultGestures:grouped];
        
//        UIPanGestureRecognizer* panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panIconMultiple:)];
//        UIPanGestureRecognizer* panConnectorGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panConnector:)];
//        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapIconMultiple:)];
//        tapGesture.numberOfTouchesRequired = 1;
//        tapGesture.numberOfTapsRequired = 2;
//        
//        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapConnector:)];
//        tapGesture2.numberOfTouchesRequired = 1;
//        tapGesture2.numberOfTapsRequired = 2;
//        
//        [_icon addGestureRecognizer:tapGesture];
//        [_icon addGestureRecognizer:panIconGesture];
//        [_connector addGestureRecognizer:panConnectorGesture];
//        [_connector addGestureRecognizer:tapGesture2];
        
        [self addSubview:_icon];
        [self addSubview:_connector];
        
        if ([self.iconType isEqualToString:@"playNote"]) {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 25, 25)];
        } else {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        }
        
        self.label.text = _iconType;
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:[P1Utils defaultFont] size:18];
        
        if (![self.iconType isEqualToString:@"touchable"]) {
            [self addSubview:self.label];
        }
    }
    return self;
}

- (void) setupDefaultGestures:(BOOL)grouped
{
    UIPanGestureRecognizer *panIconGesture = nil;
    UITapGestureRecognizer *tapIconGesture = nil;

    if (grouped) {
        panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panIconMultiple:)];
        
        tapIconGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapIconMultiple:)];
    } else {
        panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panIcon:)];
        
        tapIconGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapIcon:)];
    }
    
    tapIconGesture.numberOfTouchesRequired = 1;
    tapIconGesture.numberOfTapsRequired = 2;
    
    UIPanGestureRecognizer *panConnectorGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panConnector:)];
    
    UITapGestureRecognizer *tapConnectorGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapConnector:)];
    tapConnectorGesture.numberOfTouchesRequired = 1;
    tapConnectorGesture.numberOfTapsRequired = 2;
    
    tapConnectorGesture.delegate = self.canvas;
    tapIconGesture.delegate = self.canvas;
    
    [self.canvas.tapGesture requireGestureRecognizerToFail:tapConnectorGesture];
    [self.canvas.tapGesture requireGestureRecognizerToFail:tapIconGesture];
    
    //[tapIconGesture requireGestureRecognizerToFail:_canvas.tapGesture];
    //[tapConnectorGesture requireGestureRecognizerToFail:_canvas.tapGesture];
    
    [_icon addGestureRecognizer:tapIconGesture];
    [_icon addGestureRecognizer:panIconGesture];
    [_connector addGestureRecognizer:panConnectorGesture];
    [_connector addGestureRecognizer:tapConnectorGesture];    
}

- (id)initWithFrame:(CGRect)frame withObjectType:(ObjectType)objectType withIconType:(NSString *)iconType withConnectorType:(NSString *)connectorType withCanvas:(P1EditView *)canvas
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialConfiguration];
        [self setup:objectType withIconType:iconType withConnectorType:connectorType withCanvas:canvas];
    }
    return self;
}

-(void)initialConfiguration
{
    self.connectedObjects = [[NSMutableArray alloc] init];
    self.action = [[P1PlayAction alloc] init];
}

- (void)drawRect:(CGRect)rect
{
    if ([self.iconType isEqualToString:@"playNote"]) {
        self.label.numberOfLines = 1;
        self.label.minimumFontSize = 8.;
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.text = [P1Utils convertNumberToNoteName:self.action.value];
        //CGPointMake(self.icon.center.x, 60);
    } else {
        //self.noteLabel.text = self.;
        //self.noteLabel.center = self.icon.center;
    }
    self.label.center = self.icon.center;
    
}


@end
