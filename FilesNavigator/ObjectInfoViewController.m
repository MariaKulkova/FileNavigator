//
//  ObjectInfoViewController.m
//  FilesNavigator
//
//  Created by Maria on 28.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "ObjectInfoViewController.h"

@interface ObjectInfoViewController ()

/**
 Converts long value Unix-representation of file permissions to human-readable format
 @param permission (long) - determines permission in long type
 @return string with such format as (rwxrwxrwx)
 */
- (NSString *) convertPermissionToString: (long) permission;

/**
 Match file type and its graphical representation
 @param fileType - contains type of file
 @return image which complys with specified type of file
 */
-(UIImage*) receiveImageForFileType: (NSString*) fileType;

@end

@implementation ObjectInfoViewController

// Represent information about file system object in user interface
- (void) representObjectInfo:(FileSystemItemInfo *)objectInfo{
    
    static NSDateFormatter *dataFormat = nil;
    if (dataFormat == nil){
        dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyy.dd.MM HH:ss"];
    }
    
    self.objectImage.image = [self receiveImageForFileType:objectInfo.fileType];
    self.objectNameLabel.text = objectInfo.name;
    if (isnan(objectInfo.capacity)){
        [self.calculationSpinner startAnimating];
        self.objectSizeLabel.text = @"";
    }
    else{
        [self.calculationSpinner stopAnimating];
        self.objectSizeLabel.text = [NSByteCountFormatter stringFromByteCount:objectInfo.capacity countStyle:NSByteCountFormatterCountStyleBinary];
    }
    self.objectOwnerLabel.text = objectInfo.owner;
    self.objectGroupLabel.text = objectInfo.group;
    self.objectModifiedLabel.text = [dataFormat stringFromDate:objectInfo.lastModified];
    self.objectAccessLabel.text = [self convertPermissionToString:objectInfo.accessMode];
}

// Converts long value Unix-representation of file permissions to human-readable format
- (NSString *) convertPermissionToString: (long) permission
{
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"---", @"--x", @"-w-", @"-wx", @"r--", @"r-x", @"rw-", @"rwx", nil];
    NSMutableString *result = [NSMutableString string];
    
    for (int i = 2; i >= 0; i--)
    {
        // gets each group containing three bits which represent one of permissions group
        unsigned long thisPart = (permission >> (i * 3)) & 0x7;
        [result appendString:[permissionsArray objectAtIndex:thisPart]];
        [result appendString:@" "];
    }
    
    return (result);
}

// Match file type and its graphical representation
- (UIImage*) receiveImageForFileType: (NSString*) fileType{
    UIImage* image;
    // Determines file type and sets right icon in it representation
    if ([fileType isEqualToString:NSFileTypeDirectory] || [fileType isEqualToString:NSFileTypeSymbolicLink]){
        // Directory file type
        image = [UIImage imageNamed:@"Folder_material_1024.png"];
    }
    else if ([fileType isEqualToString:NSFileTypeRegular]){
        // Regular file type
        image = [UIImage imageNamed:@"File_material_1024.png"];
    }
    else {
        // Other types of files
        image = [UIImage imageNamed:@"File_material_1024.png"];
    }
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
