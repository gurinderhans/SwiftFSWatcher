//
//  MSwiftFileWatcher.h
//  LittleFTP
//
//  Created by Gurinder Hans on 3/21/15.
//  Copyright (c) 2015 Gurinder Hans. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>

@interface SwiftFSWatcher : NSObject

/**
 Return whether the FSEventStream was successfully created.
 */
- (BOOL)watch;

- (void)stop;
- (void)remove;

+ (SwiftFSWatcher *)createWatcher;

@property (nonatomic,copy) NSMutableArray * paths;
@property (nonatomic) bool isRunning;

@property (nonatomic,copy) void (^onFileChange)(NSInteger numEvents, NSMutableArray* paths);

@end