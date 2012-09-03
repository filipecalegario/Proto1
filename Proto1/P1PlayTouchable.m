//
//  P1PlayTouchable.m
//  Proto1
//
//  Created by Filipe Calegario on 07/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1PlayTouchable.h"
#import <QuartzCore/QuartzCore.h>
#import "P1Utils.h"

@implementation P1PlayTouchable

@synthesize value = _value;
@synthesize action = _action;
@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.action = [[NSString alloc] init];
    self.value = 0;
    
    self.backgroundColor = [P1Utils myColor:@"green"];//[UIColor orangeColor];
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 5.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    //self.layer.frame = CGRectMake(30, 30, 128, 192);
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.label.textAlignment = UITextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont fontWithName:[P1Utils defaultFont] size:18];
    
    self.label.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    [self addSubview:self.label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
