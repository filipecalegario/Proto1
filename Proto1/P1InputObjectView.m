//
//  P1InputObjectView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1InputObjectView.h"

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
@synthesize connectedTo = _connectedTo;
@synthesize hasToBeDrawn = _hasToBeDrawn;
@synthesize myTag = _myTag;
@synthesize noteLabel = _noteLabel;
@synthesize auxPoint = _auxPoint;
@synthesize connectorState = _connectorState;

- (void) setConnectedTo:(P1InputObjectView *)connectedTo
{
    if(connectedTo != self && _connectedTo == nil){
        if (![connectedTo.objectType isEqualToString:_objectType] &&[connectedTo.connectorType isEqualToString:_connectorType]) {
            if(connectedTo.connectedTo == nil || connectedTo.connectedTo == self){
                _connectedTo = connectedTo;
                if (connectedTo.connectedTo == nil) {
                    _connectedTo.connectedTo = self;
                }
            }
        }
    } else if (!connectedTo){
        _connectedTo = nil;
    }
}

- (CGPoint)auxPoint
{
    CGFloat distance = 200;
    
    CGPoint auxPoint;
    if([self.objectType isEqualToString:@"input"]){
        auxPoint = CGPointMake(self.center.x + distance, self.center.y);
    } else if([self.objectType isEqualToString:@"output"]){
        auxPoint = CGPointMake(self.center.x - distance, self.center.y);
    }

    return auxPoint;
}

- (void)setup:(NSString *)objectType withIconType:(NSString *)iconType withConnectorType:(NSString *)connectorType withCanvas:(P1EditView *)canvas
{

    self.canvas = canvas;
    self.hasToBeDrawn = true;
    
    self.iconType = iconType;
    self.connectorType = connectorType;
    self.objectType = objectType;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    
    if([self.objectType isEqualToString:@"input"]){
        self.icon = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withType:iconType];
        self.connector = [[P1IconView alloc] initWithFrame:CGRectMake(100, 0, 50, 100) withType:connectorType];
    } else if([self.objectType isEqualToString:@"output"]){
        self.connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 100) withType:[NSString stringWithFormat:@"%@Flipped", connectorType]];
        self.icon = [[P1IconView alloc] initWithFrame:CGRectMake(50, 0, 100, 100) withType:iconType];
    }
    
    UIPanGestureRecognizer* panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panIcon:)];
    UIPanGestureRecognizer* panConnectorGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panConnector:)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapIcon:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapConnector:)];
    tapGesture2.numberOfTouchesRequired = 1;
    tapGesture2.numberOfTapsRequired = 2;
    
    [_icon addGestureRecognizer:tapGesture];
    [_icon addGestureRecognizer:panIconGesture];
    [_connector addGestureRecognizer:panConnectorGesture];
    [_connector addGestureRecognizer:tapGesture2];
    
    [self addSubview:_icon];
    [self addSubview:_connector];
    
    if ([self.iconType isEqualToString:@"playNote"]) {
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 25, 25)];
        self.noteLabel.text = [NSString stringWithFormat:@"%i", self.myTag];
        self.noteLabel.textAlignment = UITextAlignmentCenter;
        self.noteLabel.backgroundColor = [UIColor clearColor];
        self.noteLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        [self addSubview:self.noteLabel];
    }
}



- (id)initWithFrame:(CGRect)frame withObjectType:(NSString*)objectType withIcon:(P1IconView*)iconObject withConnector:(P1IconView*)connectorObject withCanvas:(P1EditView*)canvas
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canvas = canvas;
        self.hasToBeDrawn = true;
        
        self.iconType = iconObject.type;
        self.connectorType = connectorObject.type;
        self.objectType = objectType;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.icon = iconObject;
        self.connector = connectorObject;
        
        UIPanGestureRecognizer* panIconGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panIconMultiple:)];
        UIPanGestureRecognizer* panConnectorGesture = [[UIPanGestureRecognizer alloc] initWithTarget:_canvas action:@selector(panConnector:)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapIconMultiple:)];
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.numberOfTapsRequired = 2;
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:_canvas action:@selector(tapConnector:)];
        tapGesture2.numberOfTouchesRequired = 1;
        tapGesture2.numberOfTapsRequired = 2;
        
        [_icon addGestureRecognizer:tapGesture];
        [_icon addGestureRecognizer:panIconGesture];
        [_connector addGestureRecognizer:panConnectorGesture];
        [_connector addGestureRecognizer:tapGesture2];
        
        [self addSubview:_icon];
        [self addSubview:_connector];
        
        if ([self.iconType isEqualToString:@"playNote"]) {
            self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, 25, 25)];
        } else {
            self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        }
            self.noteLabel.text = _iconType;
            self.noteLabel.textAlignment = UITextAlignmentCenter;
            self.noteLabel.backgroundColor = [UIColor clearColor];
            self.noteLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
            [self addSubview:self.noteLabel];
        //}
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withObjectType:(NSString *)objectType withIconType:(NSString *)iconType withConnectorType:(NSString *)connectorType withCanvas:(P1EditView *)canvas
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:objectType withIconType:iconType withConnectorType:connectorType withCanvas:canvas];
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

- (void)drawRect:(CGRect)rect
{
    if ([self.iconType isEqualToString:@"playNote"]) {
        NSString* noteName;
        switch (self.myTag) {
            case 60:
                noteName = @"C";
                break;
            case 61:
                noteName = @"C#";
                break;
            case 62:
                noteName = @"D";
                break;
            case 63:
                noteName = @"D#";
                break;
            case 64:
                noteName = @"E";
                break;
            case 65:
                noteName = @"F";
                break;
            case 66:
                noteName = @"F#";
                break;
            case 67:
                noteName = @"G";
                break;
            case 68:
                noteName = @"G#";
                break;
            case 69:
                noteName = @"A";
                break;
            case 70:
                noteName = @"A#";
                break;
            case 71:
                noteName = @"B";
                break;
            default:
                noteName = [NSString stringWithFormat:@"%i", self.myTag];
                break;
        }
        self.noteLabel.text = noteName;
        //CGPointMake(self.icon.center.x, 60);
    } else {
        //self.noteLabel.text = self.;
        //self.noteLabel.center = self.icon.center;
    }
    self.noteLabel.center = self.icon.center;
    
}


@end
