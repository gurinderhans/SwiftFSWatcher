//
//  AppDelegate.swift
//  SwiftFSWatcher
//
//  Created by Gurinder Hans on 3/23/15.
//  Copyright (c) 2015 Gurinder Hans. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let watcher = SwiftFSWatcher.createWatcher()
        
        let pathsArray = ["/Users/you/Documents", "/Users/you/Desktop"]
        watcher.paths = NSMutableArray(array: pathsArray)
        watcher.watch()
        
        watcher.onFileChange = {numEvents, changedPaths in
            println("recieved: \(numEvents) events")
            println("changedPaths: \(changedPaths)")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

