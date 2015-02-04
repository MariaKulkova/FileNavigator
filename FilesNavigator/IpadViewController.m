//
//  IpadViewController.m
//  FilesNavigator
//
//  Created by Maria on 30.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "IpadViewController.h"
#import "FileRepresentViewCell.h"
#import "FileSystemItemInfo.h"
#import "ObjectsTableViewController.h"

@interface IpadViewController ()

@end

@implementation IpadViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
    
        isDetailedPanelVisible = NO;
        
        // This duplicate parent initialization. TODO: make parameters initialization as a not-init method
        ObjectsTableViewController *rootTableController = [[ObjectsTableViewController alloc] initWithFilePath:@"/"];
        rootTableController.delegate = self;
        self.navigationController = [[FileSystemNavigationController alloc] initWithRootViewController:rootTableController];
        
        self.objectInfoController = [[ObjectInfoViewController alloc] init];
    }
    return self;
}

- (IBAction)hideDetailsPanelForSwipe:(UISwipeGestureRecognizer*)recognizer{
    // Get the location of the gesture
    //CGPoint location = [recognizer locationInView:self.objectsTableView];
    
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            isDetailedPanelVisible = NO;
            [self.detailedPanelView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
            [self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
        }
    }
}

- (IBAction)showDetailsPanelForLongTapRecognizer:(UIRotationGestureRecognizer *)recognizer {
    // Get the location of the gesture
    CGPoint location = [recognizer locationInView:self.objectsTableView];
    ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
    location.x += table.tableView.contentOffset.x;
    location.y += table.tableView.contentOffset.y;

    NSIndexPath *index = [table.tableView indexPathForRowAtPoint:location];

    FileRepresentViewCell *cell = (FileRepresentViewCell*)[table.tableView cellForRowAtIndexPath:index];

    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        isDetailedPanelVisible = YES;
        cell.highlighted = YES;
        [self.detailedPanelView addSubview:self.objectInfoController.view];
        [self.objectInfoController representObjectInfo:[table.filesList objectAtIndex:index.row]];
        [self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.objectsTableView addSubview:[self.navigationController view]];
    //[self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
    
    
    //Long tap
    //-------------------------------------------------------------------------------------------------------------
    UILongPressGestureRecognizer *longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailsPanelForLongTapRecognizer:)];
    longTapRecognizer.minimumPressDuration = 2.0;
    longTapRecognizer.delegate = self;
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:longTapRecognizer];
    //-------------------------------------------------------------------------------------------------------------
    
    //Swipe
    //-------------------------------------------------------------------------------------------------------------
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailsPanelForSwipe:)];
    swipeRecognizer.delegate = self;
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:swipeRecognizer];
    //-------------------------------------------------------------------------------------------------------------

}

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) calculateObjectFrame: (CGRect) frame{
    if (isDetailedPanelVisible) {
        
        [self.objectsTableView setFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        [self.detailedPanelView setFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, self.objectsTableView.frame.size.width, self.objectsTableView.frame.size.height)];
        [self.objectInfoController.view setFrame:CGRectMake(0, 0, self.detailedPanelView.frame.size.width, self.detailedPanelView.frame.size.height)];
    }
    else{
        [self.detailedPanelView setFrame:CGRectMake(0, 0, 0, 0)];
        [self.objectsTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.navigationController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

- (void) processCompleted:(int)index{
    ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
    [self.objectInfoController representObjectInfo:[table.filesList objectAtIndex:index]];
}

@end
