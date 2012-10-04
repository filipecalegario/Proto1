//
//  P1PlayTouchable.h
//  Proto1
//
//  Created by Filipe Calegario on 07/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P1PlayTouchable : UIView

@property (nonatomic, strong) NSMutableArray* actions;
@property (nonatomic, strong) UILabel * label;

- (id)initWithFrame:(CGRect)frame;

@end
