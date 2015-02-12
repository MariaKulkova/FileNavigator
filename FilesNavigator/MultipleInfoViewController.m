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
-(UIImage*) receiveImageForFileGroup: (MultipleSelectionType) selectionType;

@end

@implementation MultipleInfoViewController

// Represent information about many file system objects in user interface
- (void) representObjectsInfo:(NSArray *)objects{
    
    filesList = objects;
    self.itemsCountLabel.text = [NSString stringWithFormat:@"%lu Items", (unsigned long)filesList.count];
    
    // size and selection type calculation
    double totalSize = 0;
    MultipleSelectionType selectionType;
    FileSystemItemInfo *firstObject = objects.firstObject;
    NSString *firstObjectType = firstObject.fileType;
    
    // Initial multipl selection type
    if ([firstObjectType isEqualToString:NSFileTypeDirectory] || [firstObjectType isEqualToString:NSFileTypeSymbolicLink]) {
        selectionType = MultipleSelectionFoldersType;
    }
    else{
        selectionType = MultipleSelectionFilesType;
    }
    
    // Total size and selection type calculation
    for (FileSystemItemInfo *item in filesList){
        
        // If some item's type isn't equal to the first item's type selection belongs to file-and-folder type
        if (![item.fileType isEqualToString:firstObjectType]) {
            selectionType = MultipleSelectionFileAndFolderType;
        }
        if (isnan(item.capacity)){
            totalSize = NAN;
            break;
        }
        else{
            totalSize += item.capacity;
        }
    }
    
    self.objectsImage.image = [self receiveImageForFileGroup: selectionType];
    
    // If some item's size hasn't been already calculated it starts calculation animation with spinner
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
- (UIImage*) receiveImageForFileGroup: (MultipleSelectionType) selectionType{

    UIImage* image;
    
    // Determines files group type and sets right icon in it representation
    switch (selectionType) {
        case MultipleSelectionFilesType:
            image = [UIImage imageNamed:@"Files_material_1024.png"];
            break;
        case MultipleSelectionFoldersType:
            image = [UIImage imageNamed:@"Folders_material_1024.png"];
            break;
        
        case MultipleSelectionFileAndFolderType:
            image = [UIImage imageNamed:@"File_folder_material_1024.png"];
            break;
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
