//
// Created by Terry Lewis on 24/6/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#include "PasswordDecryptor.h"
#include <CommonCrypto/CommonCrypto.h>
#include <iostream>
#include "ChromiumConstants.h"

@implementation PasswordDecryptor {
    void *_passwordData;
    UInt32 _passwordLength;
    unsigned char _derivedKey[kDerivedKeyInBytes];
    unsigned char _iv[kIVBlockSizeAES128];
}

- (instancetype)initWithService:(Service)service {
    self = super.init;
    if (self) {
        std::fill(_iv, _iv + kIVBlockSizeAES128, ' ');
        _passwordData = NULL;
        _service = service;
        _ready = NO;
    }
    return self;
}

- (void)dealloc {
    if (_passwordData != NULL) {
        SecKeychainItemFreeContent(NULL, _passwordData);
    }
}

- (NSString *)serviceName {
    switch (self.service) {
        case ServiceChrome:
            return @"Chrome Safe Storage";
        case ServiceChromium:
            return @"Chromium Safe Storage";
    }
    @throw [NSException exceptionWithName:@"InvalidServiceException"
                                   reason:@"The current service is unsupported." userInfo:nil];
}

- (NSString *)accountName {
    switch (self.service) {
        case ServiceChrome:
            return @"Chrome";
        case ServiceChromium:
            return @"Chromium";
    }
    @throw [NSException exceptionWithName:@"InvalidAccountException"
                                   reason:@"The selected account is of unsupported or unknown type." userInfo:nil];
}

- (SymmetricKeyResult)tryObtainSymmetricKey {
    _passwordLength = 0;

    NSString *serviceName = [self serviceName];
    UInt32 serviceNameLen = static_cast<UInt32>(serviceName.length);

    NSString *accountName = [self accountName];
    UInt32 accountNameLen = static_cast<UInt32>(accountName.length);

    OSStatus osStatus = SecKeychainFindGenericPassword(NULL, serviceNameLen, serviceName.UTF8String,
            accountNameLen, accountName.UTF8String, &_passwordLength, &_passwordData, NULL);

    if (osStatus != errSecSuccess) {
        return SymmetricKeyResultKeychainError;
    }

    int derivationPBKDFResult = CCKeyDerivationPBKDF(kCCPBKDF2,
            reinterpret_cast<const char *>(_passwordData),
            _passwordLength,
            reinterpret_cast<const uint8_t *>(kSalt),
            strlen(kSalt),
            kCCPRFHmacAlgSHA1,
            kEncryptionIterations,
            reinterpret_cast<uint8_t *>(_derivedKey),
            kDerivedKeyInBytes);

    if (derivationPBKDFResult != kCCSuccess) {
        SecKeychainItemFreeContent(NULL, _passwordData);
        _passwordData = NULL;
        return SymmetricKeyResultPBKDFDerivationError;
    }

    _ready = YES;
    return SymmetricKeyResultSuccess;
}

- (DecryptionResult)decryptPasswordV10:(std::string)encryptedPassword decryptedPassword:(std::string *)decryptedPassword {
    std::string data;

    size_t encryptedStringLen = encryptedPassword.size();
    char *encryptedString = new char[encryptedStringLen];

    size_t encryptedStringTerminatorLoc = 0;

    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt,
            kCCAlgorithmAES128,
            kCCOptionPKCS7Padding,
            _derivedKey,
            kDerivedKeyInBytes,
            _iv,
            encryptedPassword.data(),
            encryptedPassword.size(),
            encryptedString,
            encryptedStringLen,
            &encryptedStringTerminatorLoc);
    if (cryptorStatus != kCCSuccess) {
        delete[] encryptedString;
        return DecryptionResultDecryptionError;
    }
    encryptedString[encryptedStringTerminatorLoc] = '\0';

    *decryptedPassword = encryptedString;
    delete[] encryptedString;
    return DecryptionResultSuccess;
}

- (DecryptionResult)decryptPassword:(std::string)encryptedPassword decryptedPassword:(std::string *)decryptedPassword {
    if (!self.isReady) {
        @throw [NSException exceptionWithName:@"DecryptorNotReadyException"
                                       reason:@"A symmetric key has yet to be defined. "
                                               "-tryObtainSymmetricKey must be called and must return SymmetricKeyResultSuccess."
                                     userInfo:nil];
    }

    std::string trimmedCypher;
    if (encryptedPassword.find(kEncryptionVersionPrefixv10) == 0) {
        trimmedCypher = encryptedPassword.substr(strlen(kEncryptionVersionPrefixv10));
        return [self decryptPasswordV10:trimmedCypher decryptedPassword:decryptedPassword];
    } else {
        *decryptedPassword = encryptedPassword;
        return DecryptionResultUndefined;
    }
}

@end
