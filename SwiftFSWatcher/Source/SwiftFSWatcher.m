//
//  SwiftFSWatcher.m
//  LittleFTP
//
//  Created by Gurinder Hans on 3/21/15.
//  Copyright (c) 2015 Gurinder Hans. All rights reserved.
//

#import "SwiftFSWatcher.h"

@implementation SwiftFSWatcher

SwiftFSWatcher *globalSelf;

FSEventStreamRef stream;

- (instancetype)init
{
    NSLog(@"SwiftFSWatcher: Can't init directly by this method!");
    return nil;
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        self.paths = [[NSMutableArray alloc] init];
        self.onFileChange = ^(NSInteger numEvents, NSMutableArray* paths){};
        
        globalSelf = self;
        
    }
    return self;
}

+ (SwiftFSWatcher *)createWatcher
{
    return [[SwiftFSWatcher alloc]initPrivate];
}


- (BOOL)watch
{
    //create the stream
    CFArrayRef pathsToWatch = (__bridge CFArrayRef) self.paths;
    void *callbackInfo = NULL; // could put stream-specific data here.
    CFAbsoluteTime latency = 1.0; /* Latency in seconds */
    
    stream = FSEventStreamCreate(NULL,
                                 &onFileChanged,
                                 callbackInfo,
                                 pathsToWatch,
                                 kFSEventStreamEventIdSinceNow, /* Or a previous event ID */
                                 latency,
                                 kFSEventStreamCreateFlagNone /* Flags explained in reference */
                                 );
    // start the watcher
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    FSEventStreamStart(stream);
    
    self.isRunning = true;
    
    return TRUE;
}

void onFileChanged(
                   ConstFSEventStreamRef streamRef,
                   void *clientCallBackInfo,
                   size_t numEvents,
                   void *eventPaths,
                   const FSEventStreamEventFlags eventFlags[],
                   const FSEventStreamEventId eventIds[])
{
    
    int i;
    char **paths = eventPaths;
    
    NSMutableArray* changedPaths = [[NSMutableArray alloc] init];
    
    for (i=0; i < numEvents; i++) {
        [changedPaths addObject:[NSString stringWithUTF8String:paths[i]]];
    }
    
    globalSelf.onFileChange(numEvents, changedPaths);
    
}

- (void)stop
{
    self.isRunning = false;
    
    // stop watcher
    FSEventStreamStop(stream);
}

- (void)remove
{
    self.isRunning = false;
    
    // remove watcher
    FSEventStreamStop(stream);
    FSEventStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
}

- (void)dealloc
{
    self.paths = nil;
    self.onFileChange = nil;
    stream = nil;
    globalSelf = nil;
}

@end