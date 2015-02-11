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
#import "NotificationConstants.h"

@interface IpadViewController ()

@property(strong, nonatomic) UILongPressGestureRecognizer *longTapRecognizer;

@property(strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;

@property(strong, nonatomic) UITapGestureRecognizer *singleTapRecognizer;

@end

@implementation IpadViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
    
        isDetailedPanelVisible = NO;
        self.objectInfoController = [[ObjectInfoViewController alloc] init];
        self.multipleInfoController = [[MultipleInfoViewController alloc] init];
        
        // Subscribe to event of size calculation finish
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(analyzeSizeUpdate:)
         name:FINISH_CALCULATION_NOTIFICATION
         object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.objectsTableView addSubview:[self.navigationController view]];
    
    // Long tap has higher priority than single tap
    [self.singleTapRecognizer requireGestureRecognizerToFail:self.longTapRecognizer];
    
    // Load view for emty selection notification
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"EmptySelectionView" owner:self options:nil];
    self.emptySelectionView = [subviewArray objectAtIndex:0];
    
    CGRect frame = [self receiveFrameForOrientation:self.interfaceOrientation];
    [self.objectsTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.navigationController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.detailedPanelView setFrame:CGRectMake(0, 0, 0, 0)];
    
    //Long tap
    //-------------------------------------------------------------------------------------------------------------
    self.longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailsPanelForLongTapRecognizer:)];
    self.longTapRecognizer.minimumPressDuration = 0.5;
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

// Hide detailed panel by deleting its subviews and recalculating frames of views
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
            [table clearSelectedRows];
        }
    }
}

- (IBAction)showDetailsPanelForLongTapRecognizer:(UIRotationGestureRecognizer *)recognizer{
    
    // Get the location of the gesture
    CGPoint location = [recognizer locationInView:self.objectsTableView];
    ObjectsTableViewController *table = (ObjectsTableViewController*)self.navigationController.topViewController;
    location.x += table.tableView.contentOffset.x;
    location.y += table.tableView.contentOffset.y;
    
    // Receive selected cell index
    NSIndexPath *index = [table.tableView indexPathForRowAtPoint:location];

    if (recognizer.state == UIGestureRecognizerStateBegan){
        if (index != nil){
            
            // Add detailed panel to controllers view
            isDetailedPanelVisible = YES;
            [self.detailedPanelView addSubview:self.objectInfoController.view];
            [self.objectInfoController representObjectInfo:[table.filesList objectAtIndex:index.row]];
            [self calculateObjectFrame:[self receiveFrameForOrientation:self.interfaceOrientation]];
            
            [table selectCellAtIndex:index];
            self.navigationController.topViewController.navigationItem.hidesBackButton = YES;
            table.tableView.allowsSelection = NO;
            self.longTapRecognizer.enabled = NO;
            self.singleTapRecognizer.enabled = YES;
            self.swipeRecognizer.enabled = YES;
        }

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

    // If tap happened on table cell
    if (cell != nil) {
        // if this cell has already selected deselect it
        if ([table.selectedRows containsObject:index]) {
            [table deselectCellAtIndex:index];
        }
        else{
            // otherwise select it
            [table selectCellAtIndex:index];
        }
        [self updateDetailPanel];
    }
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
    
    // Increase navigation bar width to width of window
    CGRect navFrame = self.navigationController.navigationBar.frame;
    navFrame.size.width = frame.size.width;
    
    if (isDetailedPanelVisible) {
        
        // Detail panel is visible. Make left and right views occupy equal width space
        [self.detailedPanelView setFrame:CGRectMake(frame.size.width/2, navFrame.size.height + navFrame.origin.y, frame.size.width/2, frame.size.height - navFrame.size.height - navFrame.origin.y)];
        
        // Add detail panel appearance animation
        [UIView animateWithDuration:0.5 animations:^{
            [self.navigationController.navigationBar setFrame:navFrame];
            [self.objectsTableView setFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        }];
        
        [self.navigationController.view setFrame:CGRectMake(0, 0, self.objectsTableView.frame.size.width, self.objectsTableView.frame.size.height)];
        // TODO: objectInfoController - it not correct in common. It works because its view always appears first
        [self.objectInfoController.view setFrame:CGRectMake(0, 0, self.detailedPanelView.frame.size.width, self.detailedPanelView.frame.size.height)];
    }
    else{
        
        // Detail panel isn't visible. Make table view occupy all space of application
        // Add animation of detail panel disapearing.It is necessary to add navigation bar frame changing to achive correct animation effect
        [UIView animateWithDuration:0.5 animations:^{
            [self.navigationController.navigationBar setFrame:navFrame];
            [self.objectsTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        }];
        [self.navigationController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.detailedPanelView setFrame:CGRectMake(0, 0, 0, 0)];
    }
}

// when size update notification appers
- (void) analyzeSizeUpdate: (NSNotification*) notification{
    
    NSDictionary *dictionary = [notification userInfo];
    ObjectsTableViewController *tableController = (ObjectsTableViewController*)self.navigationController.topViewController;
    NSIndexPath *index = [dictionary valueForKey:INDEX_KEY];
    
    // If updating row is contained in array with selected rows activate detailed date updating
    if ([tableController.selectedRows containsObject:index]){
        [self updateDetailPanel];
    }
}

- (void) updateDetailPanel{
    // Get top table view controller
    ObjectsTableViewController *tableController = (ObjectsTableViewController*)self.navigationController.topViewController;
    
    if (tableController.selectedRows.count == 1) {
        // Single selection
        
        // Add single detailed panel to controllers view
        [self.detailedPanelView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self.detailedPanelView addSubview:self.objectInfoController.view];
        
        // Update information in detailed panel
        NSIndexPath *index = tableController.selectedRows[0];
        [self.objectInfoController representObjectInfo:[tableController.filesList objectAtIndex:index.row]];
    }
    else if (tableController.selectedRows.count > 1){
        // Multiple selection
        
        // Add multiple detailed panel to controllers view
        [self.detailedPanelView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self.detailedPanelView addSubview:self.multipleInfoController.view];
        
        // Update information in detailed panel
        NSMutableArray *selectedObjects = [[NSMutableArray alloc] init];
        for (NSIndexPath *index in tableController.selectedRows){
            [selectedObjects addObject:[tableController.filesList objectAtIndex:index.row]];
        }
        [self.multipleInfoController representObjectsInfo:[NSArray arrayWithArray:selectedObjects]];
    }
    else{
        // Empty selection
        
        // If there are no selectes cells in table
        [self.detailedPanelView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        self.emptySelectionView.frame = CGRectMake(0, 0, self.detailedPanelView.frame.size.width, self.detailedPanelView.frame.size.height);
        [self.detailedPanelView addSubview:self.emptySelectionView];
    }
}

@end
