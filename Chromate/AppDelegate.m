//
//  AppDelegate.m
//  Chromate
//
//  Created by Terry Lewis on 26/6/17.
//  Copyright © 2017 terry1994. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

static NSString *const kSafariSharedFrameworkPath = @"/System/Library/PrivateFrameworks/SafariShared.framework";
static NSString *const kSafariSharedPath = @"/System/Library/PrivateFrameworks/Safari.framework";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    NSBundle *safariSharedBundle = [NSBundle bundleWithPath:kSafariSharedFrameworkPath];
    NSLog(@"Load SafariShared: %@", [safariSharedBundle load] ? @"YES" : @"NO");

    NSBundle *safariBundle = [NSBundle bundleWithPath:kSafariSharedPath];
    NSLog(@"Load Safari: %@", [safariBundle load] ? @"YES" : @"NO");
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
