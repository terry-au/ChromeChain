//
//  ViewController.h
//  Chromate
//
//  Created by Terry Lewis on 26/6/17.
//  Copyright © 2017 terry1994. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property(weak) IBOutlet NSTableView *tableView;
@property(weak) IBOutlet NSButton *syncButton;

@end

