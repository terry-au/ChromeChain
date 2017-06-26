//
// Created by Terry Lewis on 26/6/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import "KeychainWriter.h"
#import "UICKeyChainStore.h"

static NSString *const kCommentString = @"Imported with ChromeChain.";

@implementation KeychainWriter {
}

static NSString *labelForCredential(LoginCredential *loginCredential) {
    NSMutableString *result = [[NSMutableString alloc] initWithString:loginCredential.signonRealmURL.host];
    if (loginCredential.username != nil && loginCredential.username.length > 0) {
        [result appendFormat:@" (%@)", loginCredential.username];
    }

    return result;
}


+ (BOOL)writeCredentialToKeychain:(LoginCredential *)loginCredential decryptedPassword:(NSString *)decryptedPassword {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:loginCredential.signonRealmURL
                                                              protocolType:UICKeyChainStoreProtocolTypeHTTPS
                                                        authenticationType:UICKeyChainStoreAuthenticationTypeHTMLForm];
    keychain.synchronizable = YES;
    [keychain setString:decryptedPassword
                 forKey:loginCredential.username
                  label:labelForCredential(loginCredential)
                comment:kCommentString];

    return NO;
}

@end