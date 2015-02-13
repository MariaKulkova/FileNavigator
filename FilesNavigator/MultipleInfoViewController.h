//
//  MultipleInfoViewController.h
//  FilesNavigator
//
//  Created by Maria on 04.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Represent types of many elements selection
 */
typedef enum{
    MultipleSelectionFilesType,
    MultipleSelectionFoldersType,
    MultipleSelectionFileAndFolderType
} MultipleSelectionType;

/**
 Controller represents information about many selected items from table
 */
@interface MultipleInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *filesList;
}

/// Label shows amount of selected items
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;

/// Image that indicates type of selection
@property (weak, nonatomic) IBOutlet UIImageView *objectsImage;

/// Label shows total size of all selected items
@property (weak, nonatomic) IBOutlet UILabel *totalSizeLable;

/// Spinner indicates size calculation process
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *calculationSpinner;

/// Table contains names of all selected items
@property (weak, nonatomic) IBOutlet UITableView *objectsTableView;

/**
 Represent information about many file system objects in user interface
 @param objects is an array of information about file system objects selected by user
 */
- (void) representObjectsInfo: (NSArray*) objects;

@end
