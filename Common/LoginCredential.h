//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string>


@interface LoginCredential : NSObject

@property(nonatomic, retain, readonly) NSURL *signonRealmURL;
@property(nonatomic, retain, readonly) NSString *username;
@property(nonatomic, retain, readonly) NSData *encryptedPasswordData;
@property(nonatomic, readonly) std::string encryptedPasswordString;
@property(nonatomic, readonly, getter=isValid) BOOL valid;

- (instancetype)initWithSignonRealm:(NSString *)origin username:(NSString *)username
                  encryptedPassword:(NSData *)encryptedPassword;

+ (instancetype)credentialWithSignonRealm:(NSString *)origin username:(NSString *)username
                        encryptedPassword:(NSData *)encryptedPassword;

@end
