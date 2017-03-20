//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import "LoginStore.h"
#import "FMDB/FMDB.h"
#import "LoginCredential.h"

const static NSString *const kTableName = @"logins";
const static NSString *const kActionURL = @"action_url";
const static NSString *const kUsernameValue = @"username_value";
const static NSString *const kPasswordValue = @"password_value";

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

- (BOOL)readData{
    if (!_database.open){
        return NO;
    }

    FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM ?", kTableName];
    NSMutableArray *mutableLoginCredentials = [NSMutableArray array];
    if (resultSet.next){
        NSString *actionURL = [resultSet stringForColumn:kActionURL];
        NSString *username = [resultSet stringForColumn:kUsernameValue];
        NSString *encPassword = [resultSet stringForColumn:kPasswordValue];

        LoginCredential *loginCredential = [LoginCredential credentialWithActionURL:actionURL
                                                                           username:username
                                                                  encryptedPassword:encPassword];
        [mutableLoginCredentials addObject:loginCredential];
    }
    _loginCredentials = mutableLoginCredentials;

    return [_database close];
}

@end