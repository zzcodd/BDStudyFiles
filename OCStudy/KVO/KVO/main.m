//
//  main.m
//  KVO
//
//  Created by ByteDance on 2025/7/10.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "PersonObserver.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Person *person1 = [[Person alloc] init];
        person1.name = @"张彧";
        person1.age  = 25;
        

        PersonObserver *observer = [[PersonObserver alloc] initWithPerosn:person1];
        person1.name = @"李四";  // 输出: 姓名从 张三 改为 李四
        person1.age = 30;
    }
    return 0;
}
