//
// Created by Terry Lewis on 24/6/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string>


@interface PasswordDecryptor : NSObject {
}

typedef NS_ENUM(int, Service) {
    ServiceChrome,
    ServiceChromium
};

typedef NS_ENUM(int, SymmetricKeyResult) {
    SymmetricKeyResultSuccess,
    SymmetricKeyResultKeychainError,
    SymmetricKeyResultPBKDFDerivationError
};

typedef NS_ENUM(int, DecryptionResult) {
    DecryptionResultSuccess,
    DecryptionResultUndefined,
    DecryptionResultDecryptionError
};

@property(nonatomic, readonly) Service service;

@property(nonatomic, readonly, getter=isReady) BOOL ready;

- (instancetype)initWithService:(Service)service;

- (SymmetricKeyResult)tryObtainSymmetricKey;

- (DecryptionResult)decryptPassword:(std::string)encryptedPassword decryptedPassword:(std::string *)decryptedPassword;

@end