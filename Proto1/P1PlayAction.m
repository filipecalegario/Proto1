//
//  P1PlayAction.m
//  Proto1
//
//  Created by Filipe Calegario on 03/10/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1PlayAction.h"

@implementation P1PlayAction

@synthesize value = _value;
@synthesize description = _description;

- (id)init
{
    self = [super init];
    if (self) {
        self.description = [[NSString alloc] init];
        self.value = 0;
    }
    return self;
}

@end
