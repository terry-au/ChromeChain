//
//  ViewController.m
//  Chromate
//
//  Created by Terry Lewis on 26/6/17.
//  Copyright © 2017 terry1994. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

static NSString *const kRealmCellID = @"RealmCellID";
static NSString *const kUsernameCellID = @"UsernameCellID";
static NSString *const kPasswordCellID = @"PasswordCellID";

- (void)viewDidLoad {
    [super viewDidLoad];

    [_syncButton setTarget:self];
    [_syncButton setAction:@selector(syncButtonClicked:)];

    _tableView.dataSource = self;
    _tableView.delegate = self;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)syncButtonClicked:(id)sender {
    NSLog(@"Click!");
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 3;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *textRepresentation;
    NSString *cellIdentifier;
    if (tableColumn == tableView.tableColumns[0]) {
        textRepresentation = @"1";
        cellIdentifier = kRealmCellID;
    } else if (tableColumn == tableView.tableColumns[1]) {
        textRepresentation = @"2";
        cellIdentifier = kUsernameCellID;
    } else if (tableColumn == tableView.tableColumns[2]) {
        textRepresentation = @"3";
        cellIdentifier = kPasswordCellID;
    }

    NSTableCellView *cell = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
    if (cell) {
        cell.textField.stringValue = textRepresentation;
    }
    return cell;
}


@end
