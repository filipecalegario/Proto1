//
//  P1Utils.m
//  Proto1
//
//  Created by Filipe Calegario on 06/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation P1Utils

+ (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

+ (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius withColor:(UIColor *)color inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 2*radius);
    [color setStroke];
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

+ (void)drawConnectionFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(UIColor *)myColor inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [myColor setStroke];
    UIBezierPath *pathToDraw = [UIBezierPath bezierPath];
    [pathToDraw moveToPoint:point1];
    [pathToDraw addLineToPoint:point2];
    [pathToDraw setLineWidth:5.0];
    [pathToDraw stroke];
}

+ (void)drawConnectionFrom:(CGPoint)p1 cPoint1:(CGPoint)p2 cPoint2:(CGPoint)p3 endPoint:(CGPoint)p4 withColor:(UIColor *)myColor inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    [myColor setStroke];
    UIBezierPath *pathToDraw = [UIBezierPath bezierPath];
    [pathToDraw moveToPoint:p1];
    [pathToDraw addCurveToPoint:p4 controlPoint1:p2 controlPoint2:p3];
    //[pathToDraw addLineToPoint:p4];
    [pathToDraw setLineWidth:5.0];
    [pathToDraw stroke];
}

+ (UIColor *) colorStrongOrange
{
    return [UIColor colorWithRed:0.98 green:0.412 blue:0 alpha:100];
}

+ (UIColor *) colorBrown
{
    return [UIColor colorWithRed:0.427 green:0.031 blue:0.224 alpha:100];
}

+ (UIColor *) myColor:(NSString*)colorName
{
    UIColor * result = [UIColor redColor];
    if ([colorName isEqualToString:@"strongOrange"]) {
        result = [UIColor colorWithRed:0.98 green:0.412 blue:0 alpha:100];
    } else if ([colorName isEqualToString:@"brown"]){
        result = [UIColor colorWithRed:0.427 green:0.031 blue:0.224 alpha:100];
    }
    return result;
}

+ (NSString *)convertNumberToNoteName:(int)number
{
    NSString* noteName;
    switch (number) {
        case 60:
        case 72:
            noteName = @"C";
            break;
        case 61:
        case 73:
            noteName = @"C#";
            break;
        case 62:
        case 74:
            noteName = @"D";
            break;
        case 63:
        case 75:
            noteName = @"D#";
            break;
        case 64:
        case 76:
            noteName = @"E";
            break;
        case 65:
        case 77:
            noteName = @"F";
            break;
        case 66:
        case 78:
            noteName = @"F#";
            break;
        case 67:
        case 79:
            noteName = @"G";
            break;
        case 68:
        case 80:
            noteName = @"G#";
            break;
        case 69:
        case 81:
            noteName = @"A";
            break;
        case 70:
        case 82:
            noteName = @"A#";
            break;
        case 71:
        case 83:
            noteName = @"B";
            break;
        default:
            noteName = [NSString stringWithFormat:@"%i", number];
            break;
    }
    return noteName;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]); 
    //UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *) setImage:(UIImage *)image withAlpha:(CGFloat)alpha{
    
    // Create a pixel buffer in an easy to use format
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UInt8 * m_PixelBuf = malloc(sizeof(UInt8) * height * width * 4);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(m_PixelBuf, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //alter the alpha
    int length = height * width * 4;
    for (int i=0; i<length; i+=4)
    {
        m_PixelBuf[i+3] =  255*alpha;
    }
    
    
    //create a new image
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf, width, height,
                                             bitsPerComponent, bytesPerRow, colorSpace,
                                             kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGImageRef newImgRef = CGBitmapContextCreateImage(ctx);  
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);  
    free(m_PixelBuf);
    
    UIImage *finalImage = [UIImage imageWithCGImage:newImgRef];
    CGImageRelease(newImgRef);  
    
    return finalImage;
}

+ (NSString *)formatNumberAndGiveString:(float)number
{
    float roundedValue = round(2.0f * number) / 2.0f;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];

    NSNumber * finalNumber = [NSNumber numberWithFloat:roundedValue];
    NSString * finalString = [formatter stringFromNumber:finalNumber];
    
    NSLog([NSString stringWithFormat:@"rounded:%f, %@",roundedValue, finalString]);
    
    return finalString;
}

@end
