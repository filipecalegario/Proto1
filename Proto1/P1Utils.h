//
//  P1Utils.h
//  Proto1
//
//  Created by Filipe Calegario on 06/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P1Utils : NSObject

+ (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint;

+ (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius withColor:(UIColor *)color inContext:(CGContextRef)context;

+ (void)drawConnectionFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor *)myColor inContext:(CGContextRef)context;

+ (void)drawConnectionFrom:(CGPoint)p1 cPoint1:(CGPoint)p2 cPoint2:(CGPoint)p3 endPoint:(CGPoint)p4 withColor:(UIColor *)myColor inContext:(CGContextRef)context;

+ (NSString *)convertNumberToNoteName:(int)number;

+ (UIColor *) myColor:(NSString*)colorName;

+ (UIColor *) colorStrongOrange;

+ (UIColor *) colorBrown;

@end
