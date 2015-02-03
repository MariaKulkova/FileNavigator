//
//  CommonViewController.m
//  FilesNavigator
//
//  Created by Maria on 29.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "CommonViewController.h"
#import "FileManager.h"
#import "FileSystemItemInfo.h"
#import "FileRepresentViewCell.h"
#import "ObjectInfoViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

#pragma mark - UIViewController

- (id) init{
    if (self = [super init]) {
//        NSString *pathToRoot = @"/";
//        ObjectsTableViewController *rootTableController = [[ObjectsTableViewController alloc] initWithFilePath:pathToRoot];
//        self.navigationController = [[FileSystemNavigationController alloc] initWithRootViewController:rootTableController];
    }
    return self;
}


#pragma mark - Rotation for iOS 8.0

- (void) calculateObjectFrame: (CGRect) frame{
    
}

//- (BOOL) shouldAutorotate{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationPortrait| UIInterfaceOrientationPortraitUpsideDown|UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return YES;
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    // Code here will execute before the rotation begins.
//    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        
//        // Place code here to perform animations during the rotation. You can leave this block empty if not necessary.
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        
//        // Code here will execute after the rotation has finished.
//        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
//        //[self calculateObjectFrame:[[UIScreen mainScreen] bounds]];
//    }];
//}

//#pragma mark - Rotation for earlier versions than iOS 8.0

- (CGRect) receiveFrameForOrientation: (UIInterfaceOrientation) interfaceOrientation{
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1){
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return (CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height));
        }
        else{
            return (CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.height, mainFrame.size.width));
        }
    }
    return mainFrame;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self calculateObjectFrame:[self receiveFrameForOrientation:toInterfaceOrientation]];
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
