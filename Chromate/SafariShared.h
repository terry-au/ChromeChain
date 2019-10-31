//
//  SafariShared.h
//  ChromeChain
//
//  Created by Terry Lewis on 27/6/17.
//  Copyright (c) 2017 terry1994. All rights reserved.
//

#ifndef SafariShared_h
#define SafariShared_h

#import <Foundation/Foundation.h>

@interface NSURLProtectionSpace (SafariShared)

+ (NSURLProtectionSpace *)safari_HTMLFormProtectionSpaceForURL:(NSURL *)URL;

@end

#endif /* SafariShared_h */
