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

@property(strong, nonatomic) UILongPressGestureRecognizer *longTapRecognizer;

@property(strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;

@property(strong, nonatomic) UITapGestureRecognizer *singleTapRecognizer;

@end

@implementation IpadViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
    
        isDetailedPanelVisible = NO;
        selectedItems = [[NSMutableArray alloc] init];
        self.objectInfoController = [[ObjectInfoViewController alloc] init];
        self.multipleInfoController = [[MultipleInfoViewController alloc] init];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(analyzeSizeUpdate:)
         name:@"SizeCalculationFinishedNotificator"
         object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.objectsTableView addSubview:[self.navigationController view]];
    
    //Long tap
    //-------------------------------------------------------------------------------------------------------------
    self.longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailsPanelForLongTapRecognizer:)];
    self.longTapRecognizer.minimumPressDuration = 1.0;
    self.longTapRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.longTapRecognizer];
    //-------------------------------------------------------------------------------------------------------------
    
    //Swipe
    //-------------------------------------------------------------------------------------------------------------
    self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailsPanelForSwipe:)];
    //self.swipeRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.swipeRecognizer];
    //-------------------------------------------------------------------------------------------------------------
    
    //Single tap
    //-------------------------------------------------------------------------------------------------------------
    self.singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectForTapRecognizer:)];
    self.singleTapRecognizer.numberOfTapsRequired = 1;
    self.singleTapRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.singleTapRecognizer];
    //-------------------------------------------------------------------------------------------------------------
    
    self.longTapRecognizer.enabled = YES;
    self.swipeRecognizer.enabled = NO;
    self.singleTapRecognizer.enabled = NO;
}

- (IBAction)hideDetailsPanelForSwipe:(UISwipeGestureRecognizer*)recognizer{
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        
        isDetailedPanelVisible = NO;
        [self.detailedPanelView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
        
        if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
            self.singleTapRecognizer.enabled = NO;
            self.longTapRecognizer.enabled = YES;
            self.swipeRecognizer.enabled = NO;
            self.navigationController.topViewController.navigationItem.hidesBackButton = NO;
            
            ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
            table.tableView.allowsSelection = YES;
            self.navigationController.navigationItem.backBarButtonItem.enabled = YES;
            for (NSIndexPath *index in selectedItems) {
                [table deselectCellAtIndex:index];
            }
            [selectedItems removeAllObjects];
        }
    }
}

- (IBAction)showDetailsPanelForLongTapRecognizer:(UIRotationGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateRecognized){
        // Get the location of the gesture
        CGPoint location = [recognizer locationInView:self.objectsTableView];
        ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
        location.x += table.tableView.contentOffset.x;
        location.y += table.tableView.contentOffset.y;
        
        // Receive selected cell index
        NSIndexPath *index = [table.tableView indexPathForRowAtPoint:location];
        [table selectCellAtIndex:index];
        [selectedItems addObject:index];
        
        // Add detailed panel to controllers view
        isDetailedPanelVisible = YES;
        [self.detailedPanelView addSubview:self.objectInfoController.view];
        [self.objectInfoController representObjectInfo:[table.filesList objectAtIndex:index.row]];
        [self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
        
        self.navigationController.topViewController.navigationItem.hidesBackButton = YES;
        table.tableView.allowsSelection = NO;
        self.longTapRecognizer.enabled = NO;
        self.singleTapRecognizer.enabled = YES;
        self.swipeRecognizer.enabled = YES;
    }
}

- (IBAction)selectForTapRecognizer:(id)recognizer{
    
    // Get the location of the gesture
    CGPoint location = [recognizer locationInView:self.objectsTableView];
    ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
    location.x += table.tableView.contentOffset.x;
    location.y += table.tableView.contentOffset.y;
    
    NSIndexPath *index = [table.tableView indexPathForRowAtPoint:location];
    FileRepresentViewCell *cell = (FileRepresentViewCell*)[table.tableView cellForRowAtIndexPath:index];
    
    if (cell != nil) {
        if ([selectedItems containsObject:index]) {
            [table deselectCellAtIndex:index];
            [selectedItems removeObject:index];
        }
        else{
            [table selectCellAtIndex:index];
            [selectedItems addObject:index];
        }
        [self updateDetailPanel];
    }
}

//// Implement the UIGestureRecognizerDelegate method
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if ([touch view] == self.objectInfoController.view) {
//        return NO;
//    }
//    return YES;
//}

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

- (void) analyzeSizeUpdate: (NSNotification*) notification{
    NSDictionary *dictionary = [notification userInfo];
    NSIndexPath *index = [dictionary valueForKey:@"Index"];
    if ([selectedItems containsObject:index]){
        [self updateDetailPanel];
    }
}

- (void) updateDetailPanel{
    ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
    if (selectedItems.count == 1) {
        [self.multipleInfoController.view removeFromSuperview];
        [self.detailedPanelView addSubview:self.objectInfoController.view];
        
        NSIndexPath *index = selectedItems[0];
        FileSystemItemInfo *item = [table.filesList objectAtIndex:index.row];
        NSLog(@"%f", item.capacity);
        [self.objectInfoController representObjectInfo:item];
    }
    else{
        // Add multiple detailed panel to controllers view
        [self.objectInfoController.view removeFromSuperview];
        [self.detailedPanelView addSubview:self.multipleInfoController.view];
        [self.multipleInfoController.view setFrame:self.objectInfoController.view.frame];
        NSMutableArray *selectedObjects = [[NSMutableArray alloc] init];
        for (NSIndexPath *index in selectedItems){
            [selectedObjects addObject:[table.filesList objectAtIndex:index.row]];
        }
        [self.multipleInfoController representObjectsInfo:[NSArray arrayWithArray:selectedObjects]];
    }
}

@end
