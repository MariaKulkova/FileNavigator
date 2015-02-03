//
//  FileManager.h
//  FilesNavigator
//
//  Created by Maria on 16.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Hidden option enum
 HiddenInclude - hidden files are included into result content set
 HiddenExclude - hidden files aren't included
 */
typedef enum{
    HiddenInclude,
    HiddenExclude
} Hiddening;

/**
 Gives an ability to receive information about file ystem objects
 */
@interface FileManager : NSObject
{
    BOOL isInterrupted;
    dispatch_semaphore_t semaphore;
}

/**
 Gives an information about files at the current path
 @param path (NSString*) - path to directory which content is necessary to show
 @return array of attributes of files, which are contained in a directory at path parameter
 */
- (NSMutableArray*) receiveFiles: (NSString*) path withHideOption: (Hiddening) hideOption;

/**
 Calculates real size of a directory recursively
 @param path contains path to directory which size is necessary to calculate
 @return real size of the directory
 */
- (double) receiveDirectorySizeRecursive: (NSString*) path;

/**
 Allows to interrupt size computation process by recursion interruption
 */
- (void) interruptProcessing;

@end

