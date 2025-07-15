//
//  ByteDancer.m
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/3.
//

#import "ByteDancer.h"

@implementation Task

-(instancetype)initWithDescription:(NSString *)description taskID:(NSString *)taskID{
    self = [super init];
    if(self){
        _workDescription = description;
        _taskID = taskID;
        _isCompleted = NO;
    }
    return self;
}

@end



@implementation ByteDancer

-(instancetype)init{
    self = [super init];
    if(self){
        _impression = [NSMutableString string];
        _skills = [NSMutableArray array];
        _extraInfo = [NSMutableDictionary dictionary];
        _hasSignedConfidentialityAgreement = NO;
    }
    return self;
}

-(void)work{
    NSLog(@"%@ 正在工作中...", self.name);
}

-(NSString*)stringFromGender{
    switch (_gender) {
        case 0: return @"male"; // break
        case 1: return @"female";
        default: return @"unknown";
    }
}

-(void)signConfidentialityAgreement{
    self.hasSignedConfidentialityAgreement = YES;
    NSLog(@"%@ 已签署保密协议", self.name);
}

-(BOOL)hasSignedAgreement{
    return _hasSignedConfidentialityAgreement;
}

@end
