//
//  MultipleInfoViewController.m
//  FilesNavigator
//
//  Created by Maria on 04.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "MultipleInfoViewController.h"
#import "FileSystemItemInfo.h"

@interface MultipleInfoViewController ()

/**
 Match file type and its graphical representation
 @param fileType - contains type of file
 @return image which complys with specified type of file
 */
-(UIImage*) receiveImageForFileGroup;

@end

@implementation MultipleInfoViewController

// Represent information about many file system objects in user interface
- (void) representObjectsInfo:(NSArray *)objects{
    
    filesList = objects;
    self.objectsImage.image = [self receiveImageForFileGroup];
    self.itemsCountLabel.text = [NSString stringWithFormat:@"%d", filesList.count];
    double totalSize = [self calculateTotalSize];
    
    if (isnan(totalSize)) {
        [self.calculationSpinner startAnimating];
        self.totalSizeLable.text = @"";
    }
    else{
        [self.calculationSpinner stopAnimating];
        self.totalSizeLable.text = [NSByteCountFormatter stringFromByteCount:totalSize countStyle:NSByteCountFormatterCountStyleBinary];
    }
    
    [self.objectsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"filesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    FileSystemItemInfo *fileListItem = [filesList objectAtIndex:indexPath.row];
    
    // Cell fields filling
    cell.textLabel.text = fileListItem.name;
    return cell;
}

// calculate total size of all received objects
// If some object has NAN capacity total size is NAN too
- (double) calculateTotalSize{
    double totalSize = 0;
    for (FileSystemItemInfo *item in filesList){
        if (isnan(item.capacity)){
            totalSize = NAN;
            break;
        }
        else{
            totalSize += item.capacity;
        }
    }
    return totalSize;
}

// Match file type and its graphical representation
- (UIImage*) receiveImageForFileGroup{
    NSMutableArray *tempFilesList = [[filesList sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    UIImage* image;
    
    // Determines files group type and sets right icon in it representation
    // In dorted list directories goes before files. It means that if the first and the last objects are directories there are no files in list.
    // If the first object is regular file there are no directories in list
    FileSystemItemInfo *firstObject = tempFilesList.firstObject;
    FileSystemItemInfo *lastObject = tempFilesList.lastObject;
    if ([firstObject.fileType isEqualToString:NSFileTypeDirectory] || [firstObject.fileType isEqualToString:NSFileTypeSymbolicLink]){
        if ([lastObject.fileType isEqualToString:NSFileTypeDirectory] || [lastObject.fileType isEqualToString:NSFileTypeSymbolicLink]){
            // Many directories
            image = [UIImage imageNamed:@"folders_big.png"];
        }
        else{
            // Files and directories
            image = [UIImage imageNamed:@"file_and_folder_big"];
        }
    }
    else if ([firstObject.fileType isEqualToString:NSFileTypeRegular]){
        // Regular files
        image = [UIImage imageNamed:@"files_big.png"];
    }
    return image;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
