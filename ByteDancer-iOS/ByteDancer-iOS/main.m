//
//  main.m
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/3.
//

#import <Foundation/Foundation.h>
#import "ByteDancer.h"
#import "Roles.h"
#import "ByteDancer+Validation.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"=== ByteDancer iOS工程演示开始 ===\n");

        PM* pm = [[PM alloc] init];
        pm.name = @"张产品";
        pm.age = 30;
        pm.gender = GenderMale;
        pm.department = @"产品部";
        pm.productLine = @"产品线";
        [pm.skills addObjectsFromArray:@[@"产品设计", @"用户研究", @"数据分析"]];
        
        RD *rd = [[RD alloc] init];
        rd.name = @"zz";
        rd.age = 25;
        rd.gender = GenderMale;
        rd.department = @"技术部";
        rd.programmingLanguage = @"Objective-C/Swift";
        [rd.skills addObjectsFromArray:@[@"iOS开发", @"架构设计", @"性能优化"]];
        
        QA *qa = [[QA alloc] init];
        qa.name = @"王测试";
        qa.age = 24;
        qa.gender = GenderFemale;
        qa.department = @"质量部";
        qa.testingTools = @[@"Xcode", @"Instruments", @"Charles", @"Appium"];
        [qa.skills addObjectsFromArray:@[@"功能测试", @"性能测试", @"自动化测试"]];
        
        HR *hr = [[HR alloc] init];
        hr.name = @"陈人事";
        hr.age = 30;
        hr.gender = GenderFemale;
        hr.department = @"人力资源部";
        hr.departmentResponsibilities = @{
            @"招聘": @"负责人才招聘和面试安排",
            @"培训": @"组织员工培训和发展计划",
            @"福利": @"管理员工福利和社保事务"
        };
        [hr.skills addObjectsFromArray:@[@"人才招聘", @"员工关系", @"薪酬管理"]];
        

        
        NSLog(@"=== 1. 员工入职流程 ===");
        // HR安排签署保密协议
        [hr arrangConfidentialityAgreementFor:rd];
        [hr arrangConfidentialityAgreementFor:qa];
        [hr arrangConfidentialityAgreementFor:pm];
        [hr signConfidentialityAgreement]; // HR自己签署
        
        // 社保代理
        rd.socialSecurityDelegate = hr;
        qa.socialSecurityDelegate = hr;
        // 员工委托HR代缴社保
        NSLog(@"\n--- 社保代缴流程 ---");
        [hr paySocialSecurityForEmployee:rd];
        [hr paySocialSecurityForEmployee:qa];
        
        NSLog(@"\n=== 2. 员工资格验证 ===");
        NSArray *employees = @[pm,rd,qa,hr];
        for(ByteDancer *employee in employees){
            NSLog(@"%@", [employee getQualificationReport]);
        }
        
        
        NSLog(@"\n=== 3. 工作流程演示 ===");
        [pm work];
        [rd work];
        [qa work];
        [hr work];

        NSLog(@"\n=== 4. 任务开发流程 ===");
        // PM创建任务
        Task* task = [pm createProductTask:@"feat:视频播放"];
        // RD开发
        [rd developTask:task completion:^(BOOL success, NSString* message){
            NSLog(@"开发完成回调：%@ - %@", success ? @"成功" : @"失败", message);
            
            [qa testTask:task completion:^(BOOL testSuccess, NSString* testMessage){
                NSLog(@"测试完成回调：%@ - %@", testSuccess ? @"通过" : @"失败", testMessage);
                if(testSuccess){
                    [rd mergeCode:task];
                    NSLog(@"🎉 任务 %@ 完成整个开发流程！", task.taskID);
                }else{
                    NSLog(@"❌ 任务 %@ 需要重新开发", task.taskID);
                }
            }];
        }
        ];
    
    NSLog(@"\n=== 5. 等待异步任务完成 ===");
    // 等待异步任务完成
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    
    NSLog(@"\n=== ByteDancer iOS工程演示结束 ===");
        
    }
    return 0;
}
