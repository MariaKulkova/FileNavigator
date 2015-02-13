//
//  ObjectsTableViewController.h
//  FilesNavigator
//
//  Created by Maria on 02.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileRepresentViewCell.h"

/**
 Controller allows to interact with table view that represents contain of file system
 */
@interface ObjectsTableViewController : UITableViewController <UIDocumentInteractionControllerDelegate>
{
    // Custom queue for one directory size calculation task storage
    dispatch_queue_t sizeCalculationQueue;
    
    // Custom queue for current directory's content sizes calculation task
    dispatch_queue_t commonCalculationQueue;
    
    // Semaphor for synchronization of manipulations with array of FileManager instances links (fileManagrLinks)
    dispatch_semaphore_t fileManagerLinksSemaphor;
    
    // Semaphor for synchronization of manipulations with interruption flag (cancelledSizeCalculation)
    dispatch_semaphore_t cancelledCalculationsSemaphor;
    
    // Determines whether callculation process was interrupted
    BOOL cancelledSizeCalculation;
    
    // Store links to FileManager instances to control any computational processes excuted by it
    NSMutableArray *fileManagerLinks;
    
    // Allows to preview documents
    UIDocumentInteractionController *documentInteractionController;
}

/// Contains path to file which is reviewed by current controller
@property (strong, nonatomic) NSString *reviewedFilePath;

/// Contains information about file system objects
@property (strong, nonatomic) NSArray *filesList;

/// Contains index paths to rows which were selected by user
@property (readonly) NSArray *selectedRows;

/**
 Initializes controller instance with path to file system object which content must be shown
 It also initializes recursive asynchronous computation of directories real sizes
 @param filePath represents path to file system object which content must be shown
 @return new instance of controller
 */
- (id) initWithFilePath: (NSString*) filePath;

/**
 Interrupts any asynchronous calculation processes by setting special interruption flag
 */
- (void) cancelCalculations;

/**
 Organize selection of the cell which is located at specified indeex path
 @param indexPath is a location of the cell
 */
- (void) selectCellAtIndex: (NSIndexPath*) indexPath;

/**
 Remove selection from the cell which is located at specified path
@param indexPath is a location of the cell
 */
- (void) deselectCellAtIndex: (NSIndexPath*) indexPath;

/**
 Deselect all selected rows and clear array of selected rows
 */
- (void) clearSelectedRows;

@end
