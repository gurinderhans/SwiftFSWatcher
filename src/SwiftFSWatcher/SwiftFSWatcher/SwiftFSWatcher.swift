//
//  SwiftFSWatcher.swift
//  SwiftFSWatcher
//
//  Created by Gurinder Hans on 4/9/16.
//  Copyright © 2016 Gurinder Hans. All rights reserved.
//

import Foundation

public class SwiftFSWatcher {
    
    var watchingPaths:[String]
    
    var isRunning = false
    
    var stream:FSEventStreamRef?
    
    public var onChange: ((String) -> ())!
    
    
    /// MARK: - init methods
    
    public init(paths: [String]) {
        self.watchingPaths = paths
    }
    
    public func watch() {
        
        var context = FSEventStreamContext(version: 0, info: UnsafeMutablePointer<Void>(unsafeAddressOf(self)), retain: nil, release: nil, copyDescription: nil)
        
        stream = FSEventStreamCreate(kCFAllocatorDefault, innerEventCallback, &context, watchingPaths, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 1.0, UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents))
        
        FSEventStreamScheduleWithRunLoop(stream!, NSRunLoop.currentRunLoop().getCFRunLoop(), kCFRunLoopDefaultMode)
        FSEventStreamStart(stream!)
        
        isRunning = true
    }
    
    
    private let innerEventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutablePointer<Void>, numEvents: Int, eventPaths: UnsafeMutablePointer<Void>, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIds: UnsafePointer<FSEventStreamEventId>) in
        
        let fileSystemWatcher: SwiftFSWatcher = unsafeBitCast(contextInfo, SwiftFSWatcher.self)
        
        let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]
        fileSystemWatcher.onChange(paths)
    }
    
    private func onChange(eventPaths: [String]) {
        print("eventPaths:  \(eventPaths)")
    }
}