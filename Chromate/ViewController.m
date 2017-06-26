//
//  ViewController.m
//  Chromate
//
//  Created by Terry Lewis on 26/6/17.
//  Copyright © 2017 terry1994. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_syncButton setTarget:self];
    [_syncButton setAction:@selector(syncButtonClicked:)];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)syncButtonClicked:(id)sender {
    NSLog(@"Click!");
}

@end
