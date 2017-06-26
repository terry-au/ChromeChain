//
// Created by Terry Lewis on 26/6/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginCredential.h"


@interface KeychainWriter : NSObject

+ (BOOL)writeCredentialToKeychain:(LoginCredential *)loginCredential decryptedPassword:(NSString *)decryptedPassword;

@end