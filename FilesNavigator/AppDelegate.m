//
//  AppDelegate.m
//  FilesNavigator
//
//  Created by Maria on 16.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonViewController.h"
#import "IphoneViewController.h"
#import "IpadViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window, navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    CommonViewController *rootFilesViewController;
//    if ([deviceModel rangeOfString:@"iPad"].location != NSNotFound){
//        rootFilesViewController = [[IpadViewController alloc] init];
//    }else if ([deviceModel rangeOfString:@"iPhone"].location != NSNotFound){
//        rootFilesViewController = [[IphoneViewController alloc] init];
//    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        self.window.rootViewController = [[IphoneViewController alloc] init];
    }
    else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"iPadController"];
    }
    
//    navigationController = [[FileSystemNavigationController alloc]
//                            initWithRootViewController:rootFilesViewController];
    
//    id windows = application.windows;
//    window = windows[0];//[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    window.rootViewController = rootFilesViewController;
    [window makeKeyAndVisible];
    //[window addSubview:[rootFilesViewController view]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
