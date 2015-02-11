//
//  IpadViewController.h
//  FilesNavigator
//
//  Created by Maria on 30.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "CommonViewController.h"
#import "ObjectInfoViewController.h"
#import "FileSystemNavigationController.h"
#import "MultipleInfoViewController.h"

@interface IpadViewController : CommonViewController <UIGestureRecognizerDelegate>
{
    // flag that shows whether detailed panel is visible or not
    BOOL isDetailedPanelVisible;
}

/// View controller for single object detailed information representation
@property (strong, nonatomic) ObjectInfoViewController *objectInfoController;

/// View controller for group object detailed information representation
@property (strong, nonatomic) MultipleInfoViewController *multipleInfoController;

// View which appears, when no items were selected
@property (strong, nonatomic) UIView *emptySelectionView;

/// Represents view for navigation controller storage
@property (weak, nonatomic) IBOutlet UIView *objectsTableView;

/// Represents view for detailed information controllers storage
@property (weak, nonatomic) IBOutlet UIView *detailedPanelView;

@end
