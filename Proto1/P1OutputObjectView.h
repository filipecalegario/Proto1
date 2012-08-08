//
//  P1OutputObjectView.h
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1EditView.h"
#import "P1IconView.h"

@interface P1OutputObjectView : UIView

@property (nonatomic, strong) NSString* relatedPatch;

- (id)initWithFrame:(CGRect)frame relatedPatch:(NSString *)patch;

@end
