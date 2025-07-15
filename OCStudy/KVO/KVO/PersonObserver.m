//
//  PersonObserver.m
//  KVO
//
//  Created by ByteDance on 2025/7/10.
//

#import "PersonObserver.h"
 

@implementation PersonObserver

- (instancetype)initWithPerosn:(Person *)person{
    self = [super init];
    if(self){
        self.person = person;
        
        // 添加观察者
        [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];

        
    }
    
    return  self;
}

// 实现观察方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"name"]) {
        NSString *oldName = change[NSKeyValueChangeOldKey];
        NSString *newName = change[NSKeyValueChangeNewKey];
        NSLog(@"姓名从 %@ 改为 %@", oldName, newName);
        
    } else if ([keyPath isEqualToString:@"age"]) {
        NSNumber *newAge = change[NSKeyValueChangeNewKey];
        NSLog(@"年龄变为 %@", newAge);
    }
    
    
    // 打印change字典的所有内容
    NSLog(@"change字典内容: %@", change);
    
    // 常用的key
    NSNumber *kind = change[NSKeyValueChangeKindKey];           // 变化类型
    id newValue = change[NSKeyValueChangeNewKey];               // 新值
    id oldValue = change[NSKeyValueChangeOldKey];               // 旧值
    NSArray *indexes = change[NSKeyValueChangeIndexesKey];      // 索引（数组变化时）
    NSNumber *isPrior = change[NSKeyValueChangeNotificationIsPriorKey]; // 是否为前置通知
    NSLog(@"%@ - %@ - %@ - %@",newValue , oldValue, indexes, isPrior);
    // 变化类型判断
    NSKeyValueChange changeKind = [kind integerValue];
    switch (changeKind) {
        case NSKeyValueChangeSetting:
            NSLog(@"属性被设置");
            break;
        case NSKeyValueChangeInsertion:
            NSLog(@"插入了元素");
            break;
        case NSKeyValueChangeRemoval:
            NSLog(@"移除了元素");
            break;
        case NSKeyValueChangeReplacement:
            NSLog(@"替换了元素");
            break;
    }
}

- (void)dealloc{
    [self.person removeObserver:self forKeyPath:@"name"];
    [self.person removeObserver:self forKeyPath:@"age"];
    NSLog(@"移除观察者");
}
@end
