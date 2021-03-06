//
//  P1InputObjectView.h
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1EditView.h"
#import "P1IconView.h"
#import "P1PlayAction.h"

typedef enum{
    INPUT,
    OUTPUT
} ObjectType;


@interface P1InputObjectView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) P1EditView* canvas;
@property (nonatomic, strong) P1IconView* icon;
@property (nonatomic, strong) P1IconView* connector;
@property (nonatomic, assign) ObjectType objectType;
@property (nonatomic, strong) NSString* iconType;
@property (nonatomic, strong) NSString* connectorType;
//@property (nonatomic, weak) P1InputObjectView* connectedTo;
@property (nonatomic, strong) NSMutableArray* connectedObjects;
@property (nonatomic, assign) BOOL hasToBeDrawn;
//@property (nonatomic, assign) int myTag;
#warning consertar essa representação de noteLabel e name
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) P1PlayAction* action;
@property (nonatomic, assign) BOOL isPartOfAGroup;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, assign) int value;


@property (nonatomic, assign) CGPoint auxPoint;

- (void) connectObject:(P1InputObjectView *)connectedTo;
- (id)initWithFrame:(CGRect)frame withObjectType:(ObjectType)objectType withIconType:(NSString *)iconType withConnectorType:(NSString *)connectorType withCanvas:(P1EditView *)canvas;
- (id)initWithFrame:(CGRect)frame withObjectType:(ObjectType)objectType withIcon:(P1IconView*)iconObject withConnector:(P1IconView*)connectorObject withCanvas:(P1EditView*)canvas groupedGestures:(BOOL)grouped;
-(void) removeConnections;
-(void)killMeNow;

@end
