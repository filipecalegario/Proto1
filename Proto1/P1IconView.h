//
//  P1IconView.h
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P1IconView : UIView

@property (nonatomic,strong) NSString* type;

- (id)initWithFrame:(CGRect)frame withType:(NSString *)type;

- (id)initWithFrame:(CGRect)frame withType:(NSString *)type withImageSource:(NSString*)imageSource;

@end
