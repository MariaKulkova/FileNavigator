//
//  MultipleInfoViewController.h
//  FilesNavigator
//
//  Created by Maria on 04.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *filesList;
}

@property (weak, nonatomic) IBOutlet UIImageView *objectsImage;

@property (weak, nonatomic) IBOutlet UILabel *totalSizeLable;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *calculationSpinner;

@property (weak, nonatomic) IBOutlet UITableView *objectsTableView;

- (void) representObjectsInfo: (NSArray*) objects;

@end
