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

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self.navigationController view]];
}

@end
