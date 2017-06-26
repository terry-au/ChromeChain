//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import "LoginCredential.h"
#import <iostream>

@interface LoginCredential () {
}
@property(nonatomic, retain) NSString *password;
@end

@implementation LoginCredential

- (instancetype)initWithSignonRealm:(NSString *)origin username:(NSString *)username
                  encryptedPassword:(NSData *)encryptedPassword {
    self = [super init];
    if (self) {
        _signonRealmURL = [NSURL URLWithString:origin];
        _username = username;
        _encryptedPasswordData = encryptedPassword;
        _valid = _signonRealmURL != nil && encryptedPassword != nil && encryptedPassword.length > 0;

        if (_valid) {
            // Explicitly define length in order to ensure (possibly present) null terminators do not truncate encrypted
            // strings.
            const char *encryptedPasswordBytes = static_cast<const char *>(encryptedPassword.bytes);
            _encryptedPasswordString = std::string(encryptedPasswordBytes, encryptedPassword.length);
        }
    }

    return self;
}

+ (instancetype)credentialWithSignonRealm:(NSString *)origin username:(NSString *)username
                        encryptedPassword:(NSData *)encryptedPassword {
    return [[self alloc] initWithSignonRealm:origin username:username encryptedPassword:encryptedPassword];
}

@end
