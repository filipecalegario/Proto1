//
//  P1IconView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1IconView.h"

@implementation P1IconView

@synthesize type = _type;

- (void)setup:(NSString *)type withImageSource:(NSString*)imageSource
{
    self.contentMode = UIViewContentModeRedraw;
    self.type = type;
    UIImageView *image1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageSource]];
    [self addSubview:image1];
}

- (id)initWithFrame:(CGRect)frame withType:(NSString *)type withImageSource:(NSString*)imageSource
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:type withImageSource:imageSource];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:type withImageSource:type];
    }
    return self;
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
