//
//  main.m
//  NetWork
//
//  Created by ByteDance on 2025/7/11.
//

#import <Foundation/Foundation.h>
#import "NetWorkDemo.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NetWorkDemo *mydemo = [[NetWorkDemo alloc] init];
        [mydemo performGETRequest];
        [mydemo performPOSTRequest];
        
        [[NSRunLoop currentRunLoop] run];
        
    }
    return 0;
}
