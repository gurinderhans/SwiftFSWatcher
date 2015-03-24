# SwiftFSWatcher
A simple easy to use `/` extend File System watcher using Swift


Example
--------------------
```
  /* add a fs watcher to your system */
  let watcher =  SwiftFSWatcher.createWatcher()
  let pathsArray = ["/Users/you/Documents", "/Users/you/Desktop"]
  watcher.paths = NSMutableArray(array: pathsArray)
  watcher.watch()
  
  watcher.onFileChange = {numEvents, changedPaths in
      println("recieved: \(numEvents) events")
      println("changedPaths: \(changedPaths)")
  }
```
Create more than one
--------------------
```
  // my second fs watcher
  let watcher2 =  SwiftFSWatcher.createWatcher()
  let pathsArray2 = ["/Users/you/FolderA", "/Users/you/FolderB"]
  watcher2.paths = NSMutableArray(array: pathsArray2)
  watcher2.watch()
  
  watcher2.onFileChange = {numEvents, changedPaths in
      println("recieved: \(numEvents) events")
      println("changedPaths: \(changedPaths)")
  }
  
```

Getting Started
--------------------
Three easy steps:
+ Add the `.m` & `.h` files in `Sources/` to somewhere in your project
+ Create a Bridging-Header file and import the header file as:
  * `#import "SwiftFSWatcher.h"`
+ Use it in your app

Questions and what not?
--------------------
Have a question? Feel free to contact me <a href="mailto:hello@gurinderhans.me?Subject=SwiftFSWatcher-Github" target="_top">online</a>.

You added a new feature?
--------------------
Send it in right now! I can't wait to see what you've done!

Found a Bug?
--------------------
Oh No!
Send in a pull request with the patch (very much appreciated) or just contact me :D

License
--------------------
I'll get to this, eventually...
