//
//  ObjectInfoViewController.m
//  FilesNavigator
//
//  Created by Maria on 28.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "ObjectInfoViewController.h"

@interface ObjectInfoViewController ()

@end

@implementation ObjectInfoViewController

- (void) representObjectInfo:(FileSystemItemInfo *)objectInfo{
    self.objectNameLabel.text = objectInfo.name;
    if (objectInfo.capacity == -1){
        [self.calculationSpinner startAnimating];
    }
    else{
        [self.calculationSpinner stopAnimating];
        self.objectSizeLabel.text = [NSByteCountFormatter stringFromByteCount:objectInfo.capacity countStyle:NSByteCountFormatterCountStyleBinary];
    }
    self.objectOwnerLabel.text = objectInfo.owner;
    self.objectGroupLabel.text = objectInfo.group;
    self.objectAccessLabel.text = [NSString stringWithFormat:@"%ld", objectInfo.accessMode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.objectImage.image = [UIImage imageNamed:@"Folder.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
