//
//  SwiftFSWatcher.swift
//  SwiftFSWatcher
//
//  Created by Gurinder Hans on 4/9/16.
//  Copyright © 2016 Gurinder Hans. All rights reserved.
//

public class SwiftFSWatcher {
    
    var watchingPaths: [String]?
    
    var isRunning = false
    
    var stream: FSEventStreamRef?
    
    var onChangeCallback: ([String] -> Void)?
    
    
    /// MARK: - init methods
    
    public init() {}
    
    public convenience init(_ paths: [String]) {
        self.init()
        self.watchingPaths = paths
    }
    
    /// MARK: - public methods
    public func watch(changeCb: ([String] -> Void)?) {
        
        guard let paths = watchingPaths else {
            return
        }
        
        onChangeCallback = changeCb
        
        var context = FSEventStreamContext(version: 0, info: UnsafeMutablePointer<Void>(unsafeAddressOf(self)), retain: nil, release: nil, copyDescription: nil)
        
        stream = FSEventStreamCreate(kCFAllocatorDefault, innerEventCallback, &context, paths, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0, UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents))
        
        FSEventStreamScheduleWithRunLoop(stream!, NSRunLoop.currentRunLoop().getCFRunLoop(), kCFRunLoopDefaultMode)
        FSEventStreamStart(stream!)
        
        isRunning = true
    }
    
    
    /// MARK: - private closures
    
    private let innerEventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutablePointer<Void>, numEvents: Int, eventPaths: UnsafeMutablePointer<Void>, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIds: UnsafePointer<FSEventStreamEventId>) in
        
        let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]
        let fsWatcher: SwiftFSWatcher = unsafeBitCast(contextInfo, SwiftFSWatcher.self)
        fsWatcher.onChangeCallback?(paths)
    }
    
}