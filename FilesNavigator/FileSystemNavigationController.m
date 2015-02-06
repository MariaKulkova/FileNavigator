//
//  FileSystemNavigationController.m
//  FilesNavigator
//
//  Created by Maria on 22.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "FileSystemNavigationController.h"
#import "CommonViewController.h"

@interface FileSystemNavigationController ()

@end

@implementation FileSystemNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Definition of UINavigationController delegate. Describes the process of controllers popping from stack of view controllers
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    // If view controller is popped from navigation controller it interrupts process of directories sizes calculation
    ObjectsTableViewController *popedController = (ObjectsTableViewController*)[super popViewControllerAnimated:animated];
    [popedController cancelCalculations];
    return popedController;
}

@end
