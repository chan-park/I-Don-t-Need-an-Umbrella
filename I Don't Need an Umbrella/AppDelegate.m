//
//  AppDelegate.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "AppDelegate.h"
#import <SpriteKit/SpriteKit.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSInteger numberOfTimesLaunched = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchTimes"];
    if (numberOfTimesLaunched == 0) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"soundStatus"];
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"launchTimes"];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"entered background");
    SKView *view = (SKView *)self.window.rootViewController.view;
    if (view) {
        view.paused = YES;
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    SKView *view = (SKView *)self.window.rootViewController.view;
    if (view) {
        view.paused = NO;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"became active");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
