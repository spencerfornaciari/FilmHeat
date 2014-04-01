//
//  SFAppDelegate.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/20/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFAppDelegate.h"
#import "SFTutorialViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation SFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //BOOL tutorial = FALSE;
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationBarColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"startupTutorial"]) {
//        [[NSUserDefaults standardUserDefaults] setInteger:80 forKey:@"varianceThreshold"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        SFTutorialViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"tutorial"];
//        self.window.rootViewController = viewController;
//    }

    [Crashlytics startWithAPIKey:@"532795e0d25b45a680534c336246204778a0a137"];
    
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
    // Saves changes in the application's managed object context before the application terminates.
}


@end
