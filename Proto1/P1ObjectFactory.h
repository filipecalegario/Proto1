//
//  P1ObjectFactory.h
//  Proto1
//
//  Created by Filipe Calegario on 03/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P1InputObjectView.h"
#import "P1EditView.h"

@interface P1ObjectFactory : NSObject

+ (UIView *)createAfrobeatWithCanvas:(P1EditView *)canvas;
+ (UIView *)createNoteFlowWithCanvas:(P1EditView *)canvas;
+ (UIView *)createNoteArrayWithCanvas:(P1EditView *)canvas withGestureHandler:(id)gestureHandler;
+ (UIView *)createSamplePlayerWithCanvas:(P1EditView *)canvas;
+ (P1InputObjectView *)createTouchable:(P1EditView *)canvas;
+(P1InputObjectView *)createInputObject:(NSString *)iconType withCanvas:(P1EditView *)canvas;

+(UIView *)createOSCNoteArrayWithCanvas:(P1EditView *)canvas withGestureHandler:(id)gestureHandler;

@end
