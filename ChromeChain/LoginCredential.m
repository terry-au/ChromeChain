//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import "LoginCredential.h"

@interface LoginCredential (Private)
@property (nonatomic, retain) NSString *password;
@end

@implementation LoginCredential {

}
- (instancetype)initWithActionURL:(NSString *)actionURL username:(NSString *)username
                encryptedPassword:(NSData *)encryptedPassword {
    self = [super init];
    if (self) {
        self.actionURL = actionURL;
        self.username = username;
        self.encryptedPassword = encryptedPassword;
    }

    return self;
}

+ (instancetype)credentialWithActionURL:(NSString *)actionURL username:(NSString *)username
                      encryptedPassword:(NSData *)encryptedPassword {
    return [[self alloc] initWithActionURL:actionURL username:username encryptedPassword:encryptedPassword];
}

- (NSString *)decryptedPassword:(NSString *)cypher {
    return nil;
}


@end