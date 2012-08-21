//
//  P1CircleTouchable.m
//  Proto1
//
//  Created by Filipe Calegario on 21/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1CircleTouchable.h"
#import "P1InputObjectView.h"
#import "P1IconView.h"
#import "P1Utils.h"

@implementation P1CircleTouchable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [P1Utils drawCircleAtPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) withRadius:31 withColor:[UIColor redColor] inContext:UIGraphicsGetCurrentContext()];
}


@end
