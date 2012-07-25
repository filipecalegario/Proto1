//
//  P1EditView.h
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P1EditView : UIView

- (void)panIcon:(UIPanGestureRecognizer *)gesture;
- (void)panIconMultiple:(UIPanGestureRecognizer *)gesture;
- (void)panConnector:(UIPanGestureRecognizer *)gesture;
- (void)swipeConnection:(UISwipeGestureRecognizer *)gesture;
- (void)tapIcon:(UITapGestureRecognizer *)gesture;
- (void)tapIconMultiple:(UITapGestureRecognizer *)gesture;
- (void)tapConnector:(UITapGestureRecognizer *)gesture;

@end
