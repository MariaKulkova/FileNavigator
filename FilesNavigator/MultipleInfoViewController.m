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

@end

@implementation MultipleInfoViewController

- (id) init{
    if (self = [super init]) {
    }
    return self;
}

- (void) representObjectsInfo:(NSArray *)objects{
    filesList = objects;
    double totalSize = [self calculateTotalSize];
    if (totalSize == -1) {
        [self.calculationSpinner startAnimating];
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
    
    static NSString* cellIdentifier = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    FileSystemItemInfo *fileListItem = [filesList objectAtIndex:indexPath.row];
    
    // Cell fields filling
    cell.textLabel.text = fileListItem.name;
    return cell;
}

- (double) calculateTotalSize{
    double totalSize = 0;
    for (FileSystemItemInfo *item in filesList){
        if (item.capacity == -1){
            totalSize = -1;
            break;
        }
        else{
            totalSize += item.capacity;
        }
    }
    return totalSize;
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
