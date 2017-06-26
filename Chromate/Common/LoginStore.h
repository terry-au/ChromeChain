//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginCredential.h"

@interface LoginStore : NSObject

@property(nonatomic, strong) NSString *path;
@property(nonatomic, copy, readonly) NSArray<LoginCredential *> *credentials;

- (instancetype)initWithPath:(NSString *)path;

- (BOOL)readData;

+ (instancetype)storeWithPath:(NSString *)path;

@end