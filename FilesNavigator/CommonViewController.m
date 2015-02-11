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

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        NSString *pathToRoot = @"/";
        ObjectsTableViewController *rootTableController = [[ObjectsTableViewController alloc] initWithFilePath:pathToRoot];
        self.navigationController = [[FileSystemNavigationController alloc] initWithRootViewController:rootTableController];
    }
    return self;
}

- (CGRect) receiveFrameForOrientation: (UIInterfaceOrientation) interfaceOrientation{
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
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
