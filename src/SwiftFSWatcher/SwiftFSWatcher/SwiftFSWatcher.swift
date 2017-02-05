//
//  SwiftFSWatcher.swift
//  SwiftFSWatcher
//
//  Created by Gurinder Hans on 4/9/16.
//  Copyright © 2016 Gurinder Hans. All rights reserved.
//

@objc public class SwiftFSWatcher : NSObject {
    
    var stream: FSEventStreamRef?
    
    var onChangeCallback: (([FileEvent]) -> Void)?
    
    public var watchingPaths: [String]? {
        didSet {
            guard stream != nil else {
                return
            }
            
            pause()
            stream = nil
            watch(changeCb: onChangeCallback)
        }
    }
    
    
    // MARK: - Init methods
    
    public override init() {
        // Default init
        super.init()
    }
    
    public convenience init(_ paths: [String]) {
        self.init()
        self.watchingPaths = paths
    }
    
    // MARK: - API public methods
    
    public func watch(changeCb: (([FileEvent]) -> Void)?) {
        
        guard let paths = watchingPaths else {
            return
        }
        
        guard stream == nil else {
            return
        }
        
        onChangeCallback = changeCb
        
        var context = FSEventStreamContext(version: 0, info: UnsafeMutableRawPointer(mutating: Unmanaged.passUnretained(self).toOpaque()), retain: nil, release: nil, copyDescription: nil)
        
        stream = FSEventStreamCreate(kCFAllocatorDefault, innerEventCallback, &context, paths as CFArray, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0, UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents))
        
        FSEventStreamScheduleWithRunLoop(stream!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
        FSEventStreamStart(stream!)
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
    
    private let innerEventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutableRawPointer?, numEvents: Int, eventPaths: UnsafeMutableRawPointer, eventFlags: UnsafePointer<FSEventStreamEventFlags>?, eventIds: UnsafePointer<FSEventStreamEventId>?) in
        
        guard let eventFlags = eventFlags, let eventIds = eventIds else {
            return
        }
        
        let fsWatcher: SwiftFSWatcher = unsafeBitCast(contextInfo, to: SwiftFSWatcher.self)
        let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]
        
        var fileEvents = [FileEvent]()
        for i in 0..<numEvents {
            let event = FileEvent(path: paths[i], flag: eventFlags[i], id: eventIds[i])
            
            fileEvents.append(event)
        }
        
        fsWatcher.onChangeCallback?(fileEvents)
    }
}

@objc public class FileEvent : NSObject {
    
    public var eventPath: String!
    public var eventFlag: NSNumber!
    public var eventId: NSNumber!
    
    public init(path: String!, flag: UInt32!, id: UInt64!) {
        eventPath = path
        eventFlag = NSNumber(value: flag)
        eventId = NSNumber(value: id)
    }
}
