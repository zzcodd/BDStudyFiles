//
//  main.m
//  UIViewStudy
//
//  Created by ByteDance on 2025/7/4.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
