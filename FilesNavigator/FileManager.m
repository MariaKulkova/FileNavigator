//
//  FileManager.m
//  FilesNavigator
//
//  Created by Maria on 16.01.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "FileManager.h"
#import "FileSystemItemInfo.h"

@implementation FileManager

-(id) init{
    if (self = [super init]){
        semaphore = dispatch_semaphore_create(1);
        isInterrupted = NO;
    }
    return self;
}

// Gives an information about files at the current path
- (NSArray*) receiveFiles:(NSString *) path withHideOption:(Hiddening) hideOption
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *totalFileInfo = [[NSMutableArray alloc] initWithCapacity:10];
    
    // If object type is a symbolic link it redirects path to file which link indicates to
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
    if ([[attributes objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink]) {
        path = [fileManager destinationOfSymbolicLinkAtPath:path error:nil];
    }
    
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    NSMutableArray *directoryContent = [[NSMutableArray alloc] initWithCapacity:10];
    
    switch (hideOption) {
            // HiddenInclude - hidden files are included into result set
        case HiddenInclude:
            directoryContent = [[fileManager contentsOfDirectoryAtURL:pathURL
                                       includingPropertiesForKeys:@[]
                                                          options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                            error:nil] mutableCopy];
            // adds current and parent directories to result set
            [directoryContent addObject:[NSURL URLWithString:@"."]];
            [directoryContent addObject:[NSURL URLWithString:@".."]];
            break;
            
            // HiddenExclude - hidden files aren't include into result set
        case HiddenExclude:
            directoryContent = [[fileManager contentsOfDirectoryAtURL:pathURL
                                       includingPropertiesForKeys:@[]
                                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                                            error:nil] mutableCopy];
            break;
            
        default:
            // Array is empty
            break;
    }
    
    if (directoryContent == nil) {
        return nil;
    }
    // converts attributes to FileSystemItemInfo class
    for (NSURL *file in directoryContent) {
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:[file path] error:nil];
        [totalFileInfo addObject:[[FileSystemItemInfo alloc] initWithAttributes: attributes
                                                                   fileName:[file lastPathComponent]]];
    }
    
    return ([NSArray arrayWithArray:totalFileInfo]);
}

// Calculates real size of a directory recursively
- (double) receiveDirectorySizeRecursive: (NSString*) path{
    
    double size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // If file at current path exists no exception will appear. Dictionary of attributes will be empty, array of file contant will be also empty
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
    FileSystemItemInfo *fileInfo = [[FileSystemItemInfo alloc] initWithAttributes:attributes fileName:[path lastPathComponent]];
    
    if ([fileInfo.fileType isEqualToString:NSFileTypeDirectory]) {
        // file is a directory
        NSArray *directoryContent = [self receiveFiles:path withHideOption:HiddenInclude];
        
        for (FileSystemItemInfo *fileInfo in directoryContent) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            if (isInterrupted) {
                dispatch_semaphore_signal(semaphore);
                break;
            }
            dispatch_semaphore_signal(semaphore);
            if (![fileInfo.name isEqualToString:@"."] && ![fileInfo.name isEqualToString:@".."]) {
                size += [self receiveDirectorySizeRecursive:[path stringByAppendingPathComponent:fileInfo.name]];
            }
        }
    }
    else{
        return fileInfo.capacity;
    }
    return size;
}

// Allows to interrupt size computation process by recursion interruption
-(void) interruptProcessing{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    isInterrupted = YES;
    dispatch_semaphore_signal(semaphore);
}

@end
