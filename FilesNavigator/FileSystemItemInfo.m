//
//  FileSystemItemInfo.m
//  FilesNavigator
//
//  Created by Maria on 13.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import "FileSystemItemInfo.h"

@interface FileSystemItemInfo ()

/**
 Selector for array sorting
 @param otherObject contains object of the same type as receiver, which will be compared with it
 @return result of comparison:
 NSOrderDescending if receiver goes after otherObject
 NSOrderAscending if receiver goes before otherObject
 */
- (NSComparisonResult)compare:(FileSystemItemInfo*)otherObject;

/**
 Allows to recieve a priorty of file system object for sorting
 @param fileType - the type of file system object
 @return priority of an object for sorting.
 0 is the highest priority. Directories and symbolic links have this priority
 1 - regular files have this priority
 2 - other types of objects have this priority
 */
+ (long) receivePriorityForFile: (NSString*) fileType;

@end

@implementation FileSystemItemInfo

@synthesize fileType;
@synthesize name;
@synthesize group;
@synthesize owner;
@synthesize accessMode;
@synthesize capacity;
@synthesize lastModified;

// Default init method
- (id) init
{
    self = [super init];
    return (self);
}

// Initialize class object with attributes and file's name
- (id) initWithAttributes: (NSDictionary*) attributes fileName: (NSString*) fileName
{
    if (self = [super init]){
        [self setAttributes:attributes fileName: fileName];
    }
    return (self);
}

// Selector for array sorting
- (NSComparisonResult)compare:(FileSystemItemInfo*) otherObject{
    if (self.priority < otherObject.priority) {
        return (NSOrderedAscending);
    }
    else if (self.priority > otherObject.priority){
        return (NSOrderedDescending);
    }
    else{
        return [self.name compare:otherObject.name];
    }
}

// Allows to recieve a priorty of file system object for sorting
+ (long) receivePriorityForFile:(NSString *)fileType{
    long priority = 0;
    if ([fileType isEqualToString:NSFileTypeDirectory]) {
        priority = 0;
    }
    else if ([fileType isEqualToString:NSFileTypeSymbolicLink]){
        priority = 0;
    }
    else if ([fileType isEqualToString:NSFileTypeRegular]){
        priority = 1;
    }
    else{
        priority = 2;
    }
    return priority;
}

// Sets file attributes
// Attention: file capacity for directory file type is not actual.
// It is equal NAN. It means that it is necessary to recalculate directory size recursively
- (void) setAttributes: (NSDictionary*) attributes fileName: (NSString*) fileName
{
    self.fileType = [attributes objectForKey:NSFileType];
    self.accessMode = [[attributes objectForKey:NSFilePosixPermissions] doubleValue];
    self.linksCount = [[attributes objectForKey:NSFileReferenceCount] doubleValue];
    self.owner = [attributes objectForKey:NSFileOwnerAccountName];
    self.group = [attributes objectForKey:NSFileGroupOwnerAccountName];
    if ([self.fileType isEqualToString:NSFileTypeDirectory]) {
        self.capacity = NAN;
    }
    else{
        self.capacity = [[attributes objectForKey:NSFileSize] doubleValue];
    }
    self.lastModified = [attributes objectForKey:NSFileModificationDate];
    self.name = fileName;
    self.priority = [FileSystemItemInfo receivePriorityForFile:self.fileType];
}

@end

