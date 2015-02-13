//
//  FileSystemItemInfo.h
//  FilesNavigator
//
//  Created by Maria on 13.02.15.
//  Copyright (c) 2015 Maria. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents attributes of file
 */
@interface FileSystemItemInfo : NSObject

/// Represents type of file
@property(strong, nonatomic) NSString *fileType;

/// Represents file name
@property(strong, nonatomic) NSString *name;

/// Represents name of owning group
@property(strong, nonatomic) NSString *group;

/// Represents name of user-owner
@property(strong, nonatomic) NSString *owner;

/// Determines the date when file was modified last
@property(strong, nonatomic) NSDate *lastModified;

/// Determines Unix-permissions in a long value format
@property long accessMode;

/// Contains amount of links
@property long linksCount;

/// Represents file capacity
/// It is initialized by -1 if object is a directory
/// If it isn't a directory it is initialized by capacity received from file system
@property double capacity;

/// Priority of file system object for sorting operations
@property long priority;

/**
 Initialize class object with attributes and file's name
 @param attributes - contains dictionary of file's attributes
 @param file - contains file's name
 @return modified self
 */
- (id) initWithAttributes: (NSDictionary*) attributes fileName: (NSString*) file;

/**
 Sets file attributes
 @param attributes - contains dictionary of file's attributes
 @param file - contains file's name
 */
- (void) setAttributes: (NSDictionary*) attributes fileName: (NSString*) file;

@end
