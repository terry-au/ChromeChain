//
// Created by Terry Lewis on 20/3/17.
// Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChromeLoginStore : NSObject

@property (nonatomic, strong) NSString *path;

- (instancetype)initWithPath:(NSString *)path;

+ (instancetype)storeWithPath:(NSString *)path;

@end