//
//  ObjectInfoViewController.h
//  FilesNavigator
//
//  Created by Maria on 28.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSystemItemInfo.h"

@interface ObjectInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *objectImage;

@property (weak, nonatomic) IBOutlet UILabel *objectNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectOwnerLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectGroupLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectModifiedLabel;

@property (weak, nonatomic) IBOutlet UILabel *objectAccessLabel;

- (void) representObjectInfo: (FileSystemItemInfo*) objectInfo;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *calculationSpinner;

@end
