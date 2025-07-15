//
//  Person.m
//  ARC-MRC
//
//  Created by ByteDance on 2025/7/10.
//

#import "Person.h"

@implementation Person

+ (instancetype)createPerson{
    return [[self alloc] init];
}

+(instancetype) newPerson{
    return [[self alloc] init];
}

@end
