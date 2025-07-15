//
//  ByteDancer+Validation.m
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/4.
//

#import "ByteDancer+Validation.h"


@implementation ByteDancer (Validation)

- (BOOL)isQualifiedByteDancer {
    // 判断是否为合格的ByteDancer
    BOOL hasValidAge = self.age >= 18 && self.age <= 65;
    BOOL hasValidName = self.name.length > 0;
    BOOL hasSignedAgreement = self.hasSignedConfidentialityAgreement;
    BOOL hasSkills = self.skills.count > 0;
    BOOL hasDepartment = self.department.length > 0;
    
    return hasValidAge && hasValidName && hasSignedAgreement && hasSkills && hasDepartment;
}

- (NSString *)getQualificationReport {
    NSMutableString *report = [NSMutableString stringWithFormat:@"=== %@ 资格评估报告 ===\n", self.name];
    
    [report appendFormat:@"年龄: %ld %@\n", (long)self.age, (self.age >= 18 && self.age <= 65) ? @"✓" : @"✗"];
    [report appendFormat:@"姓名: %@ %@\n", self.name, (self.name.length > 0) ? @"✓" : @"✗"];
    [report appendFormat:@"保密协议: %@ %@\n", self.hasSignedConfidentialityAgreement ? @"已签署" : @"未签署", self.hasSignedConfidentialityAgreement ? @"✓" : @"✗"];
    [report appendFormat:@"技能数量: %lu %@\n", (unsigned long)self.skills.count, (self.skills.count > 0) ? @"✓" : @"✗"];
    [report appendFormat:@"所属部门: %@ %@\n", self.department ?: @"未分配", (self.department.length > 0) ? @"✓" : @"✗"];
    [report appendFormat:@"最终结果: %@\n", [self isQualifiedByteDancer] ? @"✅ 合格" : @"❌ 不合格"];
    
    return report;
}


@end
