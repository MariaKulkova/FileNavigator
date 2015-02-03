//
//  ObjectsTableViewController.m
//  FilesNavigator
//
//  Created by Maria on 02.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "ObjectsTableViewController.h"
#import "FileManager.h"
#import "FileSystemItemInfo.h"
#import "FileRepresentViewCell.h"

@interface ObjectsTableViewController ()

/**
 Match file type and its graphical representation
 @param fileType - contains type of file
 @return image which complys with specified type of file
 */
-(UIImage*) receiveImageForFileType: (NSString*) fileType;

@end

@implementation ObjectsTableViewController

@synthesize reviewedFilePath;


#pragma mark - UIViewController

// Initializes controller instance with path to file system object which content must be shown

- (id) initWithFilePath: (NSString*) filePath{
    if (self = [super init]){
        
        self.reviewedFilePath = filePath;
        cancelledSizeCalculation = NO;
        
        // receives content of file system object
        FileManager *currentFileManager = [[FileManager alloc] init];
        NSArray *tempFileList = [currentFileManager receiveFiles:filePath withHideOption:HiddenExclude];
        if (tempFileList == nil) {
            return nil;
        }
        self.filesList = [tempFileList sortedArrayUsingSelector:@selector(compare:)];
        
        // Synhronization objects
        fileManagerLinksSemaphor = dispatch_semaphore_create(1);
        cancelledCalculationsSemaphor = dispatch_semaphore_create(1);
        fileManagerLinks = [[NSMutableArray alloc] initWithCapacity:self.filesList.count];
        sizeCalculationQueue = dispatch_queue_create("com.FilesNavigator.sizeCalcQueue", DISPATCH_QUEUE_SERIAL);
        commonCalculationQueue = dispatch_queue_create("com.FilesNavigator.commonCalcQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_set_target_queue (commonCalculationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
        dispatch_set_target_queue (sizeCalculationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem *customBackButtom = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:nil
                                                                        action:nil];
    [self.navigationItem setBackBarButtonItem:customBackButtom];
    
    // Links sell with .nib file representing cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"reuseCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    cancelledSizeCalculation = NO;
    
    // Block initializes files' size calculation by adding tasks to queue if sizes for current file haven't yet been recalculated
    //----------------------------------------------------------------------------------------
    __weak ObjectsTableViewController *weakSelf = self;
    dispatch_async(commonCalculationQueue, ^{
        
        for (__block int i = 0; i < self.filesList.count; i++) {
            
            FileSystemItemInfo *item = self.filesList[i];
            if (item.capacity == -1) {
                dispatch_semaphore_wait(cancelledCalculationsSemaphor, DISPATCH_TIME_FOREVER);
                if (cancelledSizeCalculation) {
                    dispatch_semaphore_signal(cancelledCalculationsSemaphor);
                    break;
                }
                dispatch_semaphore_signal(cancelledCalculationsSemaphor);
                
                // Initialize size calculation for one directory from list of content. Also it upates data into the table cell if it is visible
                //----------------------------------------------------------------------------------------
                dispatch_sync(sizeCalculationQueue, ^{
                    
                    FileManager *currentFileManager = [[FileManager alloc] init];
                    
                    // FileManager instance link addition to array
                    dispatch_semaphore_wait(fileManagerLinksSemaphor, DISPATCH_TIME_FOREVER);
                    [fileManagerLinks addObject: currentFileManager];
                    dispatch_semaphore_signal(fileManagerLinksSemaphor);
                    
                    // calculates directory real size recursively
                    double directorySize = [currentFileManager receiveDirectorySizeRecursive:[reviewedFilePath stringByAppendingPathComponent:item.name]];
                    item.capacity = directorySize;
                    
                    @try {
                        if (weakSelf.tableView != nil) {
                            
                            NSArray *indexes = [weakSelf.tableView indexPathsForVisibleRows];
                            for (NSIndexPath *index in indexes) {
                                if (index.row == i) {
                                    
                                    //If row is visible updates size information
                                    dispatch_semaphore_wait(cancelledCalculationsSemaphor, DISPATCH_TIME_FOREVER);
                                    if (!cancelledSizeCalculation) {
                                        
                                        // If computation was not interrupted it updates cell
                                        //----------------------------------------------------------------------------------------
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (weakSelf.tableView != nil){
                                                [weakSelf.tableView beginUpdates];
                                                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
                                                [weakSelf.tableView endUpdates];
                                            }
                                        });
                                        //----------------------------------------------------------------------------------------
                                    }
                                    else{
                                        // If computation was interrupted it cancells calculation results
                                        FileSystemItemInfo *item = [self.filesList objectAtIndex:i];
                                        item.capacity = -1;
                                    }
                                    dispatch_semaphore_signal(cancelledCalculationsSemaphor);
                                }
                            }
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Exception appeared during rows updating. Reason: %@", exception.reason);
                    }

                });
                //----------------------------------------------------------------------------------------
            }
        }
    });
    //----------------------------------------------------------------------------------------
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // if we go to next view controller we must cancel calculation of files' sizes
    [self cancelCalculations];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"reuseCell";
    FileRepresentViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    
    // Links sell with .xib file representing cell
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    FileSystemItemInfo *fileListItem = [self.filesList objectAtIndex:indexPath.row];
    
    // Cell fields filling
    cell.fileTypeImage.image = [self receiveImageForFileType:fileListItem.fileType];
    cell.fileNameLabel.text = fileListItem.name;
    
    if ([fileListItem.fileType isEqualToString:NSFileTypeDirectory]){
        if (fileListItem.capacity == -1){
            // directory size hasn't recalculated yet
            cell.fileSizeLabel.text = @"";
            [cell.sizeCalculationSpinner startAnimating];
        }
        else{
            // it has already recalculated
            cell.fileSizeLabel.text = [NSByteCountFormatter stringFromByteCount:fileListItem.capacity countStyle:NSByteCountFormatterCountStyleBinary];
            [cell.sizeCalculationSpinner stopAnimating];
        }
    }
    else{
        cell.fileSizeLabel.text = [NSByteCountFormatter stringFromByteCount:fileListItem.capacity countStyle:NSByteCountFormatterCountStyleBinary];
    }
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    FileSystemItemInfo *fileListItem = [self.filesList objectAtIndex:indexPath.row];
    
    // Initializes new controller with path of file which has been just selected
    // Path of file represent a concatination of current directory path and name of selected file
    if ([fileListItem.fileType isEqualToString:NSFileTypeDirectory] || [fileListItem.fileType isEqualToString:NSFileTypeSymbolicLink]) {
        ObjectsTableViewController *directoryContentViewController = [[ObjectsTableViewController alloc]
                                                                initWithFilePath:[reviewedFilePath stringByAppendingPathComponent:fileListItem.name]];
        
        if (directoryContentViewController == nil) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Can't open file"
                                                               message:@"This directory content can't be shown"
                                                              delegate:self
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
            [alertView show];
        }
        else{
            directoryContentViewController.navigationItem.title = fileListItem.name;
            [self.navigationController pushViewController:directoryContentViewController animated:YES];
        }
    }
    else{
        NSURL *URL = [NSURL fileURLWithPath:[reviewedFilePath stringByAppendingPathComponent:fileListItem.name]];
        
        if (URL) {
            // Initialize Document Interaction Controller
            documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
            
            // Configure Document Interaction Controller
            [documentInteractionController setDelegate:self];
            
            // Preview PDF
            BOOL previewingResult = [documentInteractionController presentPreviewAnimated:YES];
            if (!previewingResult) {
                // show message about file preview
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Can't open file"
                                                                   message:@"This type of file can't be opened"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}

#pragma mark - UIDocumentInteractionController delegate

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

#pragma mark -

// Interrupts any asynchronous calculation processes by setting special interruption flag
- (void) cancelCalculations{
    dispatch_semaphore_wait(cancelledCalculationsSemaphor, DISPATCH_TIME_FOREVER);
    cancelledSizeCalculation = YES;
    dispatch_semaphore_signal(cancelledCalculationsSemaphor);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_semaphore_wait(fileManagerLinksSemaphor, DISPATCH_TIME_FOREVER);
        for (FileManager *item in fileManagerLinks) {
            [item interruptProcessing];
        }
        dispatch_semaphore_signal(fileManagerLinksSemaphor);
    });
}

// Match file type and its graphical representation
- (UIImage*) receiveImageForFileType: (NSString*) fileType{
    UIImage* image;
    // Determines file type and sets right icon in it representation
    if ([fileType isEqualToString:NSFileTypeDirectory] || [fileType isEqualToString:NSFileTypeSymbolicLink]){
        // Directory file type
        image = [UIImage imageNamed:@"Folder.png"];
    }
    else if ([fileType isEqualToString:NSFileTypeRegular]){
        // Regular file type
        image = [UIImage imageNamed:@"File.png"];
    }
    else {
        // Other types of files
        image = [UIImage imageNamed:@"File.png"];
    }
    return image;
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
