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
#import "P1ConnectorView.h"

@interface P1InputObjectView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) P1EditView* canvas;
@property (nonatomic, strong) P1IconView* icon;
@property (nonatomic, strong) P1IconView* connector;
@property (nonatomic, strong) NSString* objectType;
@property (nonatomic, strong) NSString* iconType;
@property (nonatomic, strong) NSString* connectorType;
@property (nonatomic, weak) P1InputObjectView* connectedTo;
@property (nonatomic, assign) BOOL hasToBeDrawn;
@property (nonatomic, assign) int myTag;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, assign) CGPoint auxPoint;

- (id)initWithFrame:(CGRect)frame withObjectType:(NSString *)objectType withIconType:(NSString *)iconType withConnectorType:(NSString *)connectorType withCanvas:(P1EditView *)canvas;
- (id)initWithFrame:(CGRect)frame withObjectType:(NSString*)objectType withIcon:(P1IconView*)iconObject withConnector:(P1IconView*)connectorObject withCanvas:(P1EditView*)canvas;

@end
