//
//  UIColor+Helpers.m
//  UIColorHelpers
//
//  Created by Joel Garrett on 5/8/13.
//  Copyright (c) 2013 WillowTree Apps, Inc. All rights reserved.
//

#import "UIColor+Helpers.h"

NSString *const UIColorPrimaryColorName = @"UIColorPrimaryColorName";
NSString *const UIColorSecondaryColorName = @"UIColorSecondaryColorName";
NSString *const UIColorTertiaryColorName = @"UIColorSecondaryColorName";

@implementation UIColor (Helpers)

+ (NSMutableDictionary *)wt_colors
{
    static NSMutableDictionary *_colorDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _colorDictionary = [NSMutableDictionary new];
    });
    return _colorDictionary;
}

+ (instancetype)primaryColor
{
    return [self colorNamed:UIColorPrimaryColorName];
}

+ (instancetype)secondaryColor
{
    return [self colorNamed:UIColorSecondaryColorName];
}

+ (instancetype)tertiaryColor
{
    return [self colorNamed:UIColorTertiaryColorName];
}

+ (instancetype)colorNamed:(NSString *)colorName
{
    return [[self wt_colors] objectForKey:colorName];
}

+ (void)setPrimaryColor:(UIColor *)color
{
    [self setColor:color forName:UIColorPrimaryColorName];
}

+ (void)setSecondaryColor:(UIColor *)color
{
    [self setColor:color forName:UIColorSecondaryColorName];
}

+ (void)setTertiaryColor:(UIColor *)color
{
    [self setColor:color forName:UIColorTertiaryColorName];
}

+ (void)setColor:(UIColor *)color forName:(NSString *)colorName
{
    NSParameterAssert(colorName);
    if (color == nil)
    {
        [[self wt_colors] removeObjectForKey:colorName];
    }
    else
    {
        [[self wt_colors] setObject:color
                             forKey:colorName];
    }
}

+ (BOOL)setColors:(NSDictionary *)colors
{
    // Validate values
    for (id value in [colors allValues])
    {
        if (![value isKindOfClass:[UIColor class]])
        {
            return NO;
        }
    }
    [[self wt_colors] setValuesForKeysWithDictionary:colors];
    return YES;
}

+ (BOOL)setColorsWithContentsOfFile:(NSString *)path
{
    NSParameterAssert(path != nil);
    NSDictionary *colors = nil;
    if ([[path pathExtension] isEqualToString:@"plist"])
    {
        colors = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    else if ([[path pathExtension] isEqualToString:@"json"])
    {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:path];
        id dict = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&error];
        
        if (!error && [dict isKindOfClass:[NSDictionary class]])
        {
            colors = dict;
        }
    }
    
    if (colors)
    {
        NSMutableDictionary *parsedColors = [NSMutableDictionary new];
        [colors enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
            
            UIColor *color = [self colorWithString:obj];
            [parsedColors setValue:color forKey:key];
            
        }];
        return [self setColors:parsedColors];
    }
    
    return NO;
}

+ (instancetype)colorWithString:(NSString *)colorString
{
    if ([colorString hasPrefix:@"rgb("] || [colorString hasPrefix:@"rgba("])
    {
        return [UIColor colorWithRGBAString:colorString];
    }
    else if ([colorString hasPrefix:@"#"] || [colorString hasPrefix:@"0x"])
    {
        return [UIColor colorWithHexString:colorString];
    }
    
    return nil;
}

+ (instancetype)colorWithHexString:(NSString *)hexString
{
    CGColorRef colorRef = CGColorCreateWithHexString(hexString);
    UIColor *color = [UIColor colorWithCGColor:colorRef];
    CGColorRelease(colorRef);
    return color;
}

+ (instancetype)colorWithHexRGB:(NSUInteger)RGB
{
    NSUInteger RGBA = (RGB << 8) | 0xFF;
    return [self colorWithHexRGBA:RGBA];
}

+ (instancetype)colorWithHexRGBA:(NSUInteger)RGBA
{
    CGColorRef colorRef = CGColorCreateWithHexRGBA(RGBA);
    UIColor *color = [UIColor colorWithCGColor:colorRef];
    CGColorRelease(colorRef);
    return color;
}

+ (instancetype)colorWithRGBAString:(NSString *)RGBAString
{
    CGColorRef colorRef = CGColorCreateWithRGBAString(RGBAString);
    UIColor *color = [UIColor colorWithCGColor:colorRef];
    CGColorRelease(colorRef);
    return color;
}

+ (instancetype)colorWith8BitRGBAColorComponents:(const CGFloat *)components
{
    CGColorRef colorRef = CGColorCreateWith8BitRGBA(components[0],
                                                    components[1],
                                                    components[2],
                                                    components[3]);
    UIColor *color = [UIColor colorWithCGColor:colorRef];
    CGColorRelease(colorRef);
    return color;
}

+ (instancetype)colorWith8BitRed:(CGFloat)red
                           green:(CGFloat)green
                            blue:(CGFloat)blue
                           alpha:(CGFloat)alpha
{
    const CGFloat components[] = {red, green, blue, alpha};
    return [self colorWith8BitRGBAColorComponents:components];
}

- (NSString *)hexStringValue
{
    NSString *hexString = nil;
    CGColorRef colorRef = [self CGColor];
    CGColorSpaceRef spaceRef = CGColorGetColorSpace(colorRef);
    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
    if (spaceRef == deviceRGB)
    {
        hexString = @"0x";
        const CGFloat *components = CGColorGetComponents(colorRef);
        int count = CGColorGetNumberOfComponents(colorRef);
        for (int index = 0; index < count; index++)
        {
            NSUInteger hex = components[index] * 0xFF;
            NSString *component = [NSString stringWithFormat:@"%02X", hex];
            hexString = [hexString stringByAppendingString:component];
        }
    }
    CGColorSpaceRelease(deviceRGB);
    return hexString;
}

- (NSString *)RGBAStringValue
{
    NSString *RGBAString = nil;
    CGColorRef colorRef = [self CGColor];
    CGColorSpaceRef spaceRef = CGColorGetColorSpace(colorRef);
    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
    if (spaceRef == deviceRGB)
    {
        NSMutableArray *components = [NSMutableArray new];
        const CGFloat *colorComponents = CGColorGetComponents(colorRef);
        int count = CGColorGetNumberOfComponents(colorRef);
        for (int index = 0; index < count; index++)
        {
           [components addObject:@(colorComponents[index] * 255.0)];
        }
        RGBAString = [NSString stringWithFormat:@"rgba(%@)",
                      [components componentsJoinedByString:@","]];
    }
    CGColorSpaceRelease(deviceRGB);
    return RGBAString;
}

@end

@implementation NSString (UIColorHelpers)

- (NSString *)hexColorString
{
    NSString *hexString = self;
    if ([hexString hasPrefix:@"#"])
    {
        hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                         withString:@"0x"];
    }
    if ([hexString hasPrefix:@"0x"])
    {
        if ([hexString length] < 10)
        {
            NSString *pattern = [hexString stringByReplacingOccurrencesOfString:@"0x"
                                                                     withString:@""];
            while ([hexString length] < 10) {
                hexString = [hexString stringByAppendingString:pattern];
            }
            
            hexString = [hexString substringToIndex:10];
            hexString = [hexString stringByReplacingCharactersInRange:NSMakeRange(8, 2)
                                                           withString:@"FF"];
        }
        
        return hexString;
    }
    return nil;
}

- (NSArray *)RGBColorComponents
{
    NSString *RGBAString = self;
    NSRange range = [RGBAString rangeOfString:@"("];
    range.location ++;
    range.length = [RGBAString rangeOfString:@")"].location - range.location;
    RGBAString = [RGBAString substringWithRange:range];
    NSArray *components = [RGBAString componentsSeparatedByString:@","];
    if ([components count] == 3)
    {
        components = [components arrayByAddingObject:@"1.0"];
    }
    if ([components count] == 4)
    {
        return components;
    }
    return nil;
}

@end
