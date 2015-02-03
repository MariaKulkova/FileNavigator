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

@interface IpadViewController : CommonViewController
{
    BOOL isDetailedPanelVisible;
}

@property (strong, nonatomic) ObjectInfoViewController *objectInfoController;

@property (weak, nonatomic) IBOutlet UIView *objectsTableView;

@property (weak, nonatomic) IBOutlet UIView *detailedPanelView;

@end
