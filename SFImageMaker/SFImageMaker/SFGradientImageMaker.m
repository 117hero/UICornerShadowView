//
//  SFGradientImageMaker.m
//  SFImageMaker
//
//  Created by Jiang on 2020/2/21.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFGradientImageMaker.h"
#import <SFImageMaker/SFImageMaker.h>

@implementation SFGradientImageMaker
+ (instancetype)isHorizontal:(BOOL)isHorizontal startColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    SFGradientImageMaker *gradient = [[self class] new];
    gradient.isHorizontal = isHorizontal;
    gradient.colors = @[startColor, endColor];
    gradient.locations = @[@(0),@(1)];
    gradient.size = isHorizontal ? CGSizeMake(SCREEN_WIDTH, 1) : CGSizeMake(1, SCREEN_HEIGHT);
    return gradient;
}
- (UIImage *)general{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat cLocations[2];
    cLocations[0] = self.locations.firstObject.doubleValue;
    cLocations[1] = self.locations.lastObject.doubleValue;
    
    NSMutableArray *colors = [NSMutableArray array];
    for (UIColor *color in self.colors) {
        [colors addObject:(__bridge id)color.CGColor];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, cLocations);
    
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.size.width, self.size.height), &CGAffineTransformIdentity);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(pathRect) * cLocations[0], CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect) * cLocations[1], CGRectGetMidY(pathRect));
    if (!self.isHorizontal) {
        startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect) * cLocations[0]);
        endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect) * cLocations[1]);
    }
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end