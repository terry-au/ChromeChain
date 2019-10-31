//
//  Safari.h
//  ChromeChain
//
//  Created by Terry Lewis on 27/6/17.
//  Copyright (c) 2017 terry1994. All rights reserved.
//

#ifndef Safari_h
#define Safari_h

#import <Foundation/Foundation.h>

@interface NSURLCredential (SafariExtras)
- (NSURLCredential *)safari_initWithUser:(id)user password:(id)password persistence:(NSURLCredentialPersistence)persistence;
@end

@interface NSURLCredentialStorage (SafariExtras)
- (id)safari_addSynchronizableCopyOfCredentialIfNeeded:(NSURLCredential *)credential
                                    forProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
@end

#endif /* Safari_h */
