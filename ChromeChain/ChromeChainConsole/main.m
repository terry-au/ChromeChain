//
//  main.m
//  ChromeChain
//
//  Created by Terry Lewis on 20/3/17.
//  Copyright (c) 2017 terry1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginStore.h"

#define _NSStringify(x) #x
#define NSStringify(x) @_NSStringify(x)

static NSString *const kTestFilesPath = NSStringify(TEST_FILES_PATH);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World! (%@)", kTestFilesPath);
    }

    NSString *testDatabasePath = [kTestFilesPath stringByAppendingPathComponent:@"login_data"];
    LoginStore *loginStore = [LoginStore storeWithPath:testDatabasePath];
    if (!loginStore.readData){
        NSLog(@"Unable to read data.");
        return -1;
    }
    
    return 0;
}
