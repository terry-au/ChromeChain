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
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        self.path = path;
        _database = [FMDatabase databaseWithPath:path];
    }

    return self;
}

+ (instancetype)storeWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

- (BOOL)readData {
    if (!_database.open) {
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