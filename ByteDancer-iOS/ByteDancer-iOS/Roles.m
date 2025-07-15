//
//  Roles.m
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/3.
//

#import "Roles.h"

@implementation PM

-(Task*)createProductTask:(NSString *)description{
    static NSInteger taskCounter = 1;
    NSString *taskID = [NSString stringWithFormat:@"TASK_%03ld", (long)taskCounter++];
    Task *task = [[Task alloc] initWithDescription:description taskID:taskID];
    NSLog(@"PM %@ 创建了新任务：%@ (ID: %@)", self.name, description, taskID);
    return task;
}

@end


@implementation RD

-(void)developTask:(Task *)task completion:(TaskCompletionBlock)completion{
    NSLog(@"RD %@ 开始开发任务：%@", self.name, task.workDescription);

    // 模拟开发过程 异步实现
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        task.isCompleted = YES;
        NSLog(@"RD %@ 完成开发任务：%@", self.name, task.workDescription);
        if (completion) {
            completion(YES, @"开发完成，提交测试");
        }
    });
}

- (void)mergeCode:(Task *)task {
    NSLog(@"RD %@ 将任务 %@ 合并到主分支", self.name, task.taskID);
}

- (void)work {
    NSLog(@"RD %@ 正在进行软件开发，使用开发语言：%@", self.name, self.programmingLanguage);
}

@end

@implementation QA

-(void)testTask:(Task *)task completion:(TaskCompletionBlock)completion{
    NSLog(@"QA %@ 开始测试任务：%@", self.name, task.workDescription);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL testPassed = arc4random_uniform(10)>2;
        if(testPassed){
            NSLog(@"QA %@ 测试通过：%@", self.name, task.workDescription);
            if (completion) {
                completion(YES, @"测试通过，可以合码");
            }
        }
        else{
            NSLog(@"QA %@ 测试发现问题：%@", self.name, task.workDescription);
            if (completion) {
                completion(NO, @"测试发现bug，需要修复");
            }
        }
    });
}

- (void)work {
    NSLog(@"QA %@ 正在进行软件测试，使用测试工具：%@", self.name, [self.testingTools componentsJoinedByString:@", "]);
}

@end



@implementation HR

-(void)arrangConfidentialityAgreementFor:(ByteDancer *)employee{
    NSLog(@"HR %@ 安排 %@ 签署保密协议", self.name, employee.name);
    [employee signConfidentialityAgreement];
}

-(void)paySocialSecurityForEmployee:(ByteDancer *)employee{
    NSLog(@"HR %@ 为员工 %@ 代缴社保", self.name, employee.name);
    [employee.extraInfo setObject:@"已缴纳" forKey:@"社保"];
}

- (void)work {
    NSLog(@"HR %@ 正在处理人力资源事务，部门职责：%@", self.name, self.departmentResponsibilities);
}

@end


