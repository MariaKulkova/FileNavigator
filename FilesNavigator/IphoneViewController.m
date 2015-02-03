//
//  IphoneViewController.m
//  FilesNavigator
//
//  Created by Maria on 30.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "IphoneViewController.h"
#import "FileSystemItemInfo.h"

@interface IphoneViewController ()

@end

@implementation IphoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self calculateObjectFrame:[[UIScreen mainScreen] bounds]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) calculateObjectFrame: (CGRect) frame{
    //[self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
}

@end
