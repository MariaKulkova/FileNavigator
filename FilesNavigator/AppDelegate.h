//
//  AppDelegate.h
//  FilesNavigator
//
//  Created by Maria on 16.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSystemNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// represents object that manages and coordinates the views an app displays on a device screen
@property (strong, nonatomic) UIWindow *window;

/// controller which provides navigation among controllers representing directory content
@property (strong, nonatomic) FileSystemNavigationController *navigationController;

@end

