//
//  SwiftFSWatcher.swift
//  SwiftFSWatcher
//
//  Created by Gurinder Hans on 4/9/16.
//  Copyright © 2016 Gurinder Hans. All rights reserved.
//

public class SwiftFSWatcher {
    
    var isRunning = false
    
    var stream: FSEventStreamRef?
    
    var onChangeCallback: ([FileEvent] -> Void)?
    
    public var watchingPaths: [String]?
    
    
    // MARK: - Init methods
    
    public init() {
        // Default init method
    }
    
    public convenience init(_ paths: [String]) {
        self.init()
        self.watchingPaths = paths
    }
    
    // MARK: - API public methods
    
    public func watch(changeCb: ([FileEvent] -> Void)?) {
        
        guard let paths = watchingPaths else {
            return
        }
        
        guard stream == nil else {
            return
        }
        
        onChangeCallback = changeCb
        
        var context = FSEventStreamContext(version: 0, info: UnsafeMutablePointer<Void>(unsafeAddressOf(self)), retain: nil, release: nil, copyDescription: nil)
        
        stream = FSEventStreamCreate(kCFAllocatorDefault, innerEventCallback, &context, paths, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0, UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents))
        
        FSEventStreamScheduleWithRunLoop(stream!, NSRunLoop.currentRunLoop().getCFRunLoop(), kCFRunLoopDefaultMode)
        FSEventStreamStart(stream!)
        
        isRunning = true
    }
    
    public func resume() {
        
        guard stream != nil else {
            return
        }
        
        FSEventStreamStart(stream!)
    }
    
    public func pause() {
        
        guard stream != nil else {
            return
        }
        
        FSEventStreamStop(stream!)
    }
    
    // MARK: - [Private] Closure passed into `FSEventStream` and is called on new file event
    
    private let innerEventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutablePointer<Void>, numEvents: Int, eventPaths: UnsafeMutablePointer<Void>, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIds: UnsafePointer<FSEventStreamEventId>) in
        
        let fsWatcher: SwiftFSWatcher = unsafeBitCast(contextInfo, SwiftFSWatcher.self)
        
        let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]
        
        var fileEvents = [FileEvent]()
        for i in 0..<numEvents {
            fileEvents.append(
                FileEvent(path: paths[i], flag: Int(eventFlags[i]), id: Int(eventIds[i]))
            )
        }
        
        fsWatcher.onChangeCallback?(fileEvents)
    }
}

public class FileEvent {
    
    public let eventPath: String!
    public let eventFlag: Int!
    public let eventId: Int!
    
    init(path: String!, flag: Int!, id: Int!) {
        eventPath = path
        eventFlag = flag
        eventId = id
    }
    
}