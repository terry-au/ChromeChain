//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginCredential : NSObject

@property (nonatomic, retain) NSString *actionURL;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSData *encryptedPassword;

- (instancetype)initWithActionURL:(NSString *)actionURL username:(NSString *)username
                encryptedPassword:(NSData *)encryptedPassword;

+ (instancetype)credentialWithActionURL:(NSString *)actionURL username:(NSString *)username
                      encryptedPassword:(NSData *)encryptedPassword;

- (NSString *)decryptedPassword:(NSString *)cypher;

@end