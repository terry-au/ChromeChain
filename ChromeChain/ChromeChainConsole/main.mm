//
//  main.m
//  ChromeChain
//
//  Created by Terry Lewis on 20/3/17.
//  Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iostream>
#import "LoginStore.h"
#import "PasswordDecryptor.h"
#import "KeychainWriter.h"

#define _NSStringify(x) #x
#define NSStringify(x) @_NSStringify(x)

static NSString *const kTestFilesPath = NSStringify(TEST_FILES_PATH);

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        // insert code here...
    }

    NSString *testDatabasePath = [kTestFilesPath stringByAppendingPathComponent:@"login_data"];

    LoginStore *loginStore = [LoginStore storeWithURL:[[NSURL alloc] initFileURLWithPath:testDatabasePath]];
    if (!loginStore.readData) {
        NSLog(@"Unable to read data.");
        return -1;
    }

    PasswordDecryptor *passwordDecryptor = [[PasswordDecryptor alloc] initWithService:ServiceChrome];
    switch ([passwordDecryptor tryObtainSymmetricKey]) {
        case SymmetricKeyResultSuccess:
            break;
        case SymmetricKeyResultKeychainError:
            std::cerr << "Unable to obtain password from keychain." << std::endl;
            break;
        case SymmetricKeyResultPBKDFDerivationError:
            std::cerr << "Unable to derive PBKDF." << std::endl;
            break;
    }
    for (LoginCredential *credential in loginStore.credentials) {
        if (!credential.isValid) {continue;}
        std::string password = credential.encryptedPasswordString;

        std::string result;
        auto x = [passwordDecryptor decryptPassword:password decryptedPassword:&result];
        switch (x) {
            case DecryptionResultDecryptionError:
                std::cerr << "Error decrypting password for: " << credential.signonRealmURL.absoluteString.UTF8String
                          << "."
                          << std::endl;
                break;
            case DecryptionResultUndefined:
                std::cout << "Password did not match any prefix." << std::endl;
            case DecryptionResultSuccess: {
//                std::cout << "URL: " << credential.signonRealmURL.absoluteString.UTF8String << " Password: " << result
//                          << std::endl;

                NSString *decryptedPassword = [NSString stringWithUTF8String:result.c_str()];
                [KeychainWriter writeCredentialToKeychain:credential decryptedPassword:decryptedPassword];

                break;
            }
        }
    }

    passwordDecryptor = nil;
    return 0;
}
