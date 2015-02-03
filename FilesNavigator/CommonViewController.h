//
//  CommonViewController.h
//  FilesNavigator
//
//  Created by Maria on 29.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSystemNavigationController.h"
#import "ObjectsTableViewController.h"

/**
 Represents controller which realize common functional for file system objects visualization
 */
@interface CommonViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) FileSystemNavigationController *navigationController;

- (CGRect) receiveFrameForOrientation: (UIInterfaceOrientation) interfaceOrientation;

@end
