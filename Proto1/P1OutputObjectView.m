//
//  P1OutputObjectView.m
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1OutputObjectView.h"

@implementation P1OutputObjectView

@synthesize relatedPatch = _relatedPatch;

- (void)setup
{
    
}

- (id)initWithFrame:(CGRect)frame relatedPatch:(NSString *)patch
{
    self = [super initWithFrame:frame];
    if (self) {
        self.relatedPatch = patch;
        [self setup];
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
