//
//  ObjectInfoViewController.h
//  FilesNavigator
//
//  Created by Maria on 28.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSystemItemInfo.h"

/**
 Controller represents information about single selected item from table
 */
@interface ObjectInfoViewController : UIViewController

/// Image that indicates type of selected item
@property (weak, nonatomic) IBOutlet UIImageView *objectImage;

/// Label represent name of selected item
@property (weak, nonatomic) IBOutlet UILabel *objectNameLabel;

/// Label represent size of selected item
@property (weak, nonatomic) IBOutlet UILabel *objectSizeLabel;

/// Label represent owner of selected item
@property (weak, nonatomic) IBOutlet UILabel *objectOwnerLabel;

/// Label represent owner group of selected item
@property (weak, nonatomic) IBOutlet UILabel *objectGroupLabel;

/// Label represent the date when item was modified last time
@property (weak, nonatomic) IBOutlet UILabel *objectModifiedLabel;

/// Label represent possix permissions of item
@property (weak, nonatomic) IBOutlet UILabel *objectAccessLabel;

/// Indicates size calculation process
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *calculationSpinner;

/**
 Represent information about file system object in user interface
 @param objectInfo is an information about object of file system
 */
- (void) representObjectInfo: (FileSystemItemInfo*) objectInfo;

@end
