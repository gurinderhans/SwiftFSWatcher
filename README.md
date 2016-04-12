# SwiftFSWatcher
A simple easy to use / extend File System watcher using Swift

# Example (Swift)

```swift
import Cocoa
import SwiftFSWatcher

class ViewController: NSViewController {

    // NOTE: - Any instance of `SwiftFSWatcher` must be class scoped, like below:

    /* This will not crash your app. */
    let fileWatcher = SwiftFSWatcher(["/var/www/html/", "/home/Downloads/"])
    let anotherWatcher = SwiftFSWatcher()

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Using `localWatcher` will crash your app. */
        // let localWatcher = SwiftFSWatcher()

        fileWatcher.watch { changeEvents in
            for ev in changeEvents {
                print("eventPath: \(ev.eventPath), eventFlag: \(ev.eventFlag), eventId: \(ev.eventId)")

                // check if this event is of a file created
                if ev.eventFlag == (kFSEventStreamEventFlagItemIsFile + kFSEventStreamEventFlagItemCreated) {
                    print("created file at path: \(ev.eventPath)")
                }

            }
        }

        // setup and listen second watcher events on files only
        anotherWatcher.watchingPaths = ["/home/myFile.txt", "/root/bash_session.txt"]
        anotherWatcher.watch { changeEvents in
            for ev in changeEvents {
                print("eventPath: \(ev.eventPath), eventFlag: \(ev.eventFlag), eventId: \(ev.eventId)")

                if ev.eventFlag == (kFSEventStreamEventFlagItemIsFile + kFSEventStreamEventFlagItemInodeMetaMod + kFSEventStreamEventFlagItemModified) {
                    print("file modified at: \(ev.eventPath)")
                }
            }
        }
    }
}
```

# Example (Objective-C)
```objc
#import "ViewController.h"
#import <SwiftFSWatcher/SwiftFSWatcher-Swift.h>

@implementation ViewController

SwiftFSWatcher * s;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    s = [[SwiftFSWatcher alloc] init];
    
    s.watchingPaths = [@[@"/path/to/some/folder/", @"/path/to/myFile.txt"] mutableCopy];
    
    [s watch:^(NSArray<FileEvent *> * aa) {
        NSLog(@"changed paths: %@", aa);
    }];
}
@end
```

# Installation (two ways)

+ Include `pod 'SwiftFSWatcher'` in your Podfile
    + You'll need to add `use_frameworks!` since the framework is built in Swift.

+ Grab the `SwiftFSWatcher.framework` and add it to your project or build the `.framework` yoursleves by downloading this project.

+ Use it in your app

# Questions?

Have a question? Feel free to <a href="mailto:hello@gurinderhans.me?Subject=SwiftFSWatcher-Github" target="_top">email me</a>.

# You added a new feature?

Send it in right now! I can't wait to see what you've done!

# Found a Bug?

Oh No! Send in a pull request with the patch (very much appreciated) or just contact me :D

# License

[MIT License](http://opensource.org/licenses/MIT) 
