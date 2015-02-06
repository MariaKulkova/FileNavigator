//
//  FileRepresentViewCell.h
//  FilesNavigator
//
//  Created by Maria on 16.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REUSE_IDENTIFICATOR @"reuseCell"

/**
 Represents TableView cell with custom design and behaviour
 */
@interface FileRepresentViewCell : UITableViewCell
{
    UIColor *defaultColor;
}

/// Represents an image which shows graphical file system object type
@property (weak, nonatomic) IBOutlet UIImageView *fileTypeImage;

/// Represents a name of file system object
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

/// Represents size of file system object
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

/// Indicates size calculation process
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sizeCalculationSpinner;

@property (weak, nonatomic) IBOutlet UIImageView *rowSelectedIndicator;

@property (nonatomic, readonly) BOOL isSelected;

- (void) setSelectedForDetailedInfo;

- (void) deselectFromDetailInfo;

@end

