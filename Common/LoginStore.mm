//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import "LoginStore.h"
#import "FMDB/FMDB.h"

static NSString *const kTableName = @"logins";
static NSString *const kActionURL = @"signon_realm";
static NSString *const kUsernameValue = @"username_value";
static NSString *const kPasswordValue = @"password_value";

@implementation LoginStore {
    FMDatabase *_database;
    NSArray<LoginCredential *> *_loginCredentials;
    NSURL *_stagingPath;
    BOOL _hasStaged;
}

- (instancetype)initWithURL:(NSURL *)path {
    self = [super init];
    if (self) {
        self.path = path;
        self.useStagingDirectory = YES;
    }

    return self;
}

+ (instancetype)storeWithURL:(NSURL *)path {
    return [[self alloc] initWithURL:path];
}

- (void)dealloc {
    [self tryCleanStagedDatabase];
}

- (BOOL)tryCleanStagedDatabase {
    NSLog(@"Attempting cleanup.");
    if (_hasStaged && [self.path isEqual:_stagingPath]) {
        // Delete the file, only now, we know it is not the user's original file.
        NSLog(@"Deleted old, staged file.");
    }
    return YES;
}

//- (BOOL)stageDatabase {
//    if (!self.useStagingDirectory) {
//        _stagingPath = self.path;
//        return YES;
//    }
//
//    [self tryCleanStagedDatabase];
//
//    NSFileManager *defaultManager = [NSFileManager defaultManager];
//    BOOL isDirectory = NO;
//    if (![defaultManager fileExistsAtPath:self.path.path isDirectory:&isDirectory] || isDirectory) {
//        NSLog(@"Input file does not exist.");
//        return NO;
//    }
//
//    NSError *error = nil;
//    NSURL *stagingPath = [NSURL fileURLWithPath:@"chromate_staging.sqlite" relativeToURL:defaultManager.temporaryDirectory];
//    [defaultManager copyItemAtURL:self.path toURL:stagingPath error:&error];
//    _stagingPath = stagingPath;
//    NSLog(@"Staged to: %@", stagingPath.path);
//
//    return error == nil;
//
//}

- (BOOL)readData {
//    if (![self stageDatabase]) {
//        NSLog(@"Stage fail.");
//        return NO;
//    }
    _database = [FMDatabase databaseWithURL:self.path];

    if (!_database.open) {
        NSLog(@"Open fail.");
        return NO;
    }

    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@", kTableName];
    FMResultSet *resultSet = [_database executeQuery:queryString];
    NSMutableArray *mutableLoginCredentials = [NSMutableArray array];
    while (resultSet.next) {
        NSString *actionURL = [resultSet stringForColumn:kActionURL];
        NSString *username = [resultSet stringForColumn:kUsernameValue];
        NSData *encPassword = [resultSet dataForColumn:kPasswordValue];

        LoginCredential *loginCredential = [LoginCredential credentialWithSignonRealm:actionURL
                                                                             username:username
                                                                    encryptedPassword:encPassword];
        [mutableLoginCredentials addObject:loginCredential];
    }
    [resultSet close];
    _loginCredentials = mutableLoginCredentials;

    return [_database close];
}

- (NSArray<LoginCredential *> *)credentials {
    return _loginCredentials;
}

@end