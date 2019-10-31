//
//  ViewController.m
//  Chromate
//
//  Created by Terry Lewis on 26/6/17.
//  Copyright © 2017 terry1994. All rights reserved.
//

#import "ViewController.h"
#import "LoginStore.h"
#import "PasswordDecryptor.h"
#import "SafariShared.h"
#import "Safari.h"

@implementation ViewController {
  LoginStore *_loginStore;
  NSArray *_credentials;
  PasswordDecryptor *_passwordDecryptor;
}

static NSString *const kRealmColumnID = @"RealmCellID";
static NSString *const kUsernameColumnID = @"UsernameCellID";
static NSString *const kPasswordColumnID = @"PasswordCellID";

static NSString *const kRealmColumnSortDescriptor = @"signonRealmURL.absoluteString";
static NSString *const kUsernameColumnSortDescriptor = @"username";

- (void)viewDidLoad {
  [super viewDidLoad];

  [_syncButton setTarget:self];
  [_syncButton setAction:@selector(syncButtonClicked:)];

  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_tableView setDoubleAction:@selector(tableViewDoubleAction:)];
  for (NSTableColumn *tableColumn in _tableView.tableColumns) {
    NSString *sortKey = nil;
    if (tableColumn == _tableView.tableColumns[0]) {
      sortKey = kRealmColumnSortDescriptor;
    } else if (tableColumn == _tableView.tableColumns[1]) {
      sortKey = kUsernameColumnSortDescriptor;
    } else {
      continue;
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES selector:@selector(compare:)];
    [tableColumn setSortDescriptorPrototype:sortDescriptor];
  }

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *applicationSupportDirectory = [paths firstObject];
  NSString *filePath = [applicationSupportDirectory stringByAppendingPathComponent:@"Google/Chrome/Default/Login Data"];

  _loginStore = [[LoginStore alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
  [self readLoginStore];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];

  _passwordDecryptor = [[PasswordDecryptor alloc] initWithService:ServiceChrome];
}

- (void)trySaveUsername:(NSString *)username password:(NSString *)password realm:(NSURL *)realm {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Information";
  alert.informativeText = [NSString stringWithFormat:@"Password: %@", password];
  [alert runModal];
  NSURLCredential *urlCredential =
//      [[NSURLCredential alloc] safari_initWithUser:username password:password persistence:NSURLCredentialPersistenceSynchronizable];
      [[NSURLCredential alloc] initWithUser:username password:password persistence:NSURLCredentialPersistenceSynchronizable];
  NSLog(@"%@", urlCredential);
  NSURLProtectionSpace *protectionSpace = [NSURLProtectionSpace safari_HTMLFormProtectionSpaceForURL:realm];

  NSURLCredentialStorage *sharedCredentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
//    NSURLCredential *addedCredential = [sharedCredentialStorage safari_addSynchronizableCopyOfCredentialIfNeeded:urlCredential forProtectionSpace:protectionSpace];
  [sharedCredentialStorage setCredential:urlCredential forProtectionSpace:protectionSpace];
  NSLog(@"%@", sharedCredentialStorage.allCredentials);
//    if (addedCredential){
//        NSLog(@"Successfully added credential.");
//    }else{
//        NSLog(@"Failed to add credential.");
//    }
}

- (void)tableViewDoubleAction:(id)sender {
  if (!_passwordDecryptor.ready) {
    [_passwordDecryptor tryObtainSymmetricKey];
  }
  NSTableView *tableView = reinterpret_cast<NSTableView *>(sender);
  NSInteger selectedRowIndex = [tableView selectedRow];
  LoginCredential *loginCredential = _credentials[static_cast<NSUInteger>(selectedRowIndex)];
  std::string decryptedPassword;
  DecryptionResult decryptionResult =
      [_passwordDecryptor decryptPassword:loginCredential.encryptedPasswordString decryptedPassword:&decryptedPassword];
  switch (decryptionResult) {
  case DecryptionResultDecryptionError:break;
  case DecryptionResultUndefined:
  case DecryptionResultSuccess: {
    NSString *decryptedPasswordString = [NSString stringWithUTF8String:decryptedPassword.c_str()];
//            NSLog(@"Realm %@", );
    [self trySaveUsername:loginCredential.username password:decryptedPasswordString realm:loginCredential.signonRealmURL];
  }
  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  _loginStore = nil;
}

- (void)dealloc {
  _loginStore = nil;
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

- (void)syncButtonClicked:(id)sender {
  NSLog(@"Click!");
}

- (void)readLoginStore {
  NSLog(@"Read: %i", [_loginStore readData]);
  _credentials = _loginStore.credentials;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return _credentials.count;
}

#pragma mark - NSTableViewDelegate

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
  NSString *textRepresentation;
  NSString *cellIdentifier;
  LoginCredential *credential = _credentials[row];
  if (tableColumn == tableView.tableColumns[0]) {
    textRepresentation = credential.signonRealmURL.absoluteString;
    cellIdentifier = kRealmColumnID;
  } else if (tableColumn == tableView.tableColumns[1]) {
    textRepresentation = credential.username;
    cellIdentifier = kUsernameColumnID;
  } else if (tableColumn == tableView.tableColumns[2]) {
    textRepresentation = @"••••••••";
    cellIdentifier = kPasswordColumnID;
  }

  NSTableCellView *cell = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
  if (cell) {
    cell.textField.stringValue = textRepresentation ?: @"";
  }
  return cell;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
  _credentials = [_credentials sortedArrayUsingDescriptors:tableView.sortDescriptors];
  [tableView reloadData];
}

@end
