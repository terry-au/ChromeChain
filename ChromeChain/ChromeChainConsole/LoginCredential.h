//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginCredential : NSObject

@property (nonatomic, retain, readonly) NSString *actionURL;
@property (nonatomic, retain, readonly) NSString *username;
@property (nonatomic, retain, readonly) NSData *encryptedPassword;
@property (nonatomic, retain, readonly) NSString *encryptedPasswordString;

- (instancetype)initWithActionURL:(NSString *)actionURL username:(NSString *)username
                encryptedPassword:(NSData *)encryptedPassword;

+ (instancetype)credentialWithActionURL:(NSString *)actionURL username:(NSString *)username
                      encryptedPassword:(NSData *)encryptedPassword;

- (NSString *)decryptedPassword:(NSString *)cypher;

@end