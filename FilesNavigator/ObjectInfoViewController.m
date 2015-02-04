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

@end

@implementation ObjectInfoViewController

- (id) init{
    if (self = [super init]) {
        dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyy.dd.MM HH:ss"];
    }
    return self;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.objectImage.image = [UIImage imageNamed:@"Folder.png"];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame = self.calculationSpinner.frame;
    frame.origin = self.objectSizeLabel.frame.origin;
    [self.calculationSpinner setFrame:frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
