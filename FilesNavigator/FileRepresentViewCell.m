//
//  FileRepresentViewCell.m
//  FilesNavigator
//
//  Created by Maria on 16.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "FileRepresentViewCell.h"

@implementation FileRepresentViewCell

@synthesize fileNameLabel;
@synthesize fileSizeLabel;
@synthesize fileTypeImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization part
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// Makes cell apperance to correspond to selected state
- (void) setSelectedForDetailedInfo{
    _isSelected = YES;
    defaultColor = [self.backgroundColor copy];
    self.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.5];
    self.rowSelectedIndicator.hidden = NO;
}

// Makes cell appearance to correspond to default state, with no selection
- (void) deselectFromDetailInfo{
    _isSelected = NO;
    self.backgroundColor = nil;
    self.rowSelectedIndicator.hidden = YES;
}

@end
