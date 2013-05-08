//
//  UIColor+Helpers.h
//  UIColorHelpers
//
//  Created by Joel Garrett on 5/8/13.
//  Copyright (c) 2013 WillowTree Apps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const UIColorPrimaryColorName;
UIKIT_EXTERN NSString *const UIColorSecondaryColorName;
UIKIT_EXTERN NSString *const UIColorTertiaryColorName;

@interface UIColor (Helpers)

+ (instancetype)primaryColor;
+ (instancetype)secondaryColor;
+ (instancetype)tertiaryColor;
+ (instancetype)colorNamed:(NSString *)colorName;

+ (void)setPrimaryColor:(UIColor *)color;
+ (void)setSecondaryColor:(UIColor *)color;
+ (void)setTertiaryColor:(UIColor *)color;
+ (void)setColor:(UIColor *)color forName:(NSString *)colorName;
+ (BOOL)setColors:(NSDictionary *)colors;
+ (BOOL)setColorsWithContentsOfFile:(NSString *)path;

+ (instancetype)colorWithString:(NSString *)colorString;
+ (instancetype)colorWithHexString:(NSString *)hexString; // #f2f2f2, 0xcbcbcbff
+ (instancetype)colorWithHexRGB:(NSUInteger)RGB; 
+ (instancetype)colorWithHexRGBA:(NSUInteger)RGBA;
+ (instancetype)colorWithRGBAString:(NSString *)RGBAString; // rgba(0.0, 0.0, 0.0, 0.0)
+ (instancetype)colorWith8BitRGBAColorComponents:(const CGFloat *)components;
+ (instancetype)colorWith8BitRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha;

- (NSString *)hexStringValue;
- (NSString *)RGBAStringValue;

@end

@interface NSString (UIColorHelpers)

- (NSString *)hexColorString;
- (NSArray *)RGBColorComponents;

@end

CG_INLINE CGColorRef CGColorCreateWith8BitRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    const CGFloat components[] = {(r / 255.0), (g / 255.0), (b / 255.0), a};
    CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(spaceRef, components);
    CGColorSpaceRelease(spaceRef);
    return colorRef;
}

CG_INLINE CGColorRef CGColorCreateWithHexRGBA(u_int32_t RBGA)
{
    return CGColorCreateWith8BitRGBA(((RBGA & 0xFF000000) >> 24),
                                     ((RBGA & 0xFF0000) >> 16),
                                     ((RBGA & 0xFF00) >> 8),
                                     (RBGA & 0xFF));
}

CG_INLINE CGColorRef CGColorCreateWithHexString(NSString *hexString)
{
    hexString = [hexString hexColorString];
    if (hexString != nil)
    {
        NSUInteger RGBA = 0x0;
        [[NSScanner scannerWithString:hexString] scanHexInt:&RGBA];
        return CGColorCreateWithHexRGBA(RGBA);
    }
    return NULL;
}

CG_INLINE CGColorRef CGColorCreateWithRGBAString(NSString *RGBAString)
{
    NSArray *components = [RGBAString RGBColorComponents];
    if ([components count] == 4)
    {
        return CGColorCreateWith8BitRGBA([components[0] floatValue],
                                         [components[1] floatValue],
                                         [components[2] floatValue],
                                         [components[3] floatValue]);
    }
    
    return NULL;
}
