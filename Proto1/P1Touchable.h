//
//  P1Touchable.h
//  Proto1
//
//  Created by Filipe Calegario on 06/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1InputObjectView.h"

@interface P1Touchable : P1InputObjectView

@property BOOL editable;

@property (nonatomic, strong) UIView * corner1;
@property (nonatomic, strong) UIView * corner2;
@property (nonatomic, strong) UIView * corner3;
@property (nonatomic, strong) UIView * corner4;

- (id)initWithFrame:(CGRect)frame withCanvas:(P1EditView *)canvas;

@end
