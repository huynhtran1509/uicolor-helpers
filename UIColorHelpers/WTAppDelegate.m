//
//  WTAppDelegate.m
//  UIColorHelpers
//
//  Created by Joel Garrett on 5/8/13.
//  Copyright (c) 2013 WillowTree Apps, Inc. All rights reserved.
//

#import "WTAppDelegate.h"
#import "UIColor+Helpers.h"

@implementation WTAppDelegate

- (void)testColorWithRGBAString
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIColor *color = [UIColor colorWithRGBAString:@"rgb(255.0, 0.0, 0.0)"];
    [[self window] setBackgroundColor:color];
    NSLog(@"Color: %@", [color RGBAStringValue]);
    
    [self performSelector:@selector(testColorWithHexString)
               withObject:nil
               afterDelay:1.5];
}

- (void)testColorWithHexString
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIColor *color = [UIColor colorWithHexString:@"#ff00ff"];
    [[self window] setBackgroundColor:color];
    NSLog(@"Color: %@", [color hexStringValue]);
    
    [self performSelector:@selector(testJSONColors)
               withObject:nil
               afterDelay:1.5];
}

- (void)testJSONColors
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    if ([UIColor setColorsWithContentsOfFile:path])
    {
        [[self window] setBackgroundColor:[UIColor colorNamed:@"color4"]];
    }
    
    [self performSelector:@selector(testPlistColors)
               withObject:nil
               afterDelay:1.5];
}

- (void)testPlistColors
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
    if ([UIColor setColorsWithContentsOfFile:path])
    {
        [[self window] setBackgroundColor:[UIColor colorNamed:@"color2"]];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self performSelector:@selector(testColorWithRGBAString)
               withObject:nil
               afterDelay:1.5];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
