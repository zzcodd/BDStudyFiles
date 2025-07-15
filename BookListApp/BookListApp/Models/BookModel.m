//
//  BookModel.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/14.
//

#import "BookModel.h"

@implementation BookModel

#pragma mark - 构造方法
+ (instancetype)bookWithDictionary:(NSDictionary *)dict{
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]){
        NSLog(@"BookModel : 传入的字典为空或者类型错误");
    }
    BookModel *book = [[BookModel alloc] init];
    
    book.abstract = [self safeStringFromDict:dict key:@"abstract"];
    book.author = [self safeStringFromDict:dict key:@"author"];
    book.bookId = [self safeStringFromDict:dict key:@"book_id"];
    book.bookName = [self safeStringFromDict:dict key:@"book_name"];
    book.thumbUrl = [self safeStringFromDict:dict key:@"thumb_url"];
    book.score = [self safeStringFromDict:dict key:@"score"];
    book.category = [self safeStringFromDict:dict key:@"category_schema"];
    book.subInfo = [self safeStringFromDict:dict key:@"sub_info"];
    book.tags = [self safeStringFromDict:dict key:@"tags"];;
    book.wordNumber = [self safeStringFromDict:dict key:@"word_number"];
    book.chapterNumber = [self safeStringFromDict:dict key:@"chapter_number"];
    
    if(![book isVaildBook]){
        NSLog(@"BookModel : 书籍数据不完整 ID-%@, name-%@ ", book.bookId, book.bookName);
    }
    return book;
}

+ (NSString *)safeStringFromDict:(NSDictionary *)dict key:(NSString *)key{
    if(!dict || !key) return @"";
    id value = dict[@"key"];
    
    if([value isKindOfClass:[NSString class]]) return value;
    else if([value isKindOfClass:[NSNumber class]]) return [value stringValue];
    else if([value isKindOfClass:[NSNull class]] || value == nil) return @"";
    else{
        NSLog(@"BookModel : 值的类型有误，值类型为%@",NSStringFromClass([value class]));
        return [value description]?:@"";
    }
}

#pragma mark - 对于数值类型进行转换
- (CGFloat)scoreValue{
    if(!self.score || self.score.length == 0){
        return 0.0;
    }
    return [self.score floatValue];
}

- (NSInteger)wordNumberValue{
    if(!self.wordNumber || self.wordNumber.length == 0){
        return 0;
    }
    return [self.wordNumber integerValue];
}

- (NSInteger)chapterNumberValue{
    if(!self.chapterNumber || self.chapterNumber.length == 0){
        return 0;
    }
    return [self.chapterNumber integerValue];
}

#pragma mark - 便捷方法
- (NSString *)formattedScore{
    if(!self.score || self.score.length == 0) return @"暂无评分";
    
    if([self.score containsString:@"分"]) return self.score;
    
    return [NSString stringWithFormat:@"%@分",self.score];
}

- (NSString *)formattedWordNumber{
    if(!self.wordNumber || self.wordNumber.length == 0) return @"字数未知";
    
    return [NSString stringWithFormat:@"%@字", self.wordNumber];
}

- (NSArray<NSString *> *)tagArray{
    if(!self.tags || self.tags.length == 0){
        return @[];
    }
    NSArray *tags = [self.tags componentsSeparatedByString:@","];
    
    // 删除首位空格
    NSMutableArray *cleanArray = [NSMutableArray array];
    for(NSString *tag in tags){
        NSString *cleanTag = [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(cleanTag.length > 0){
            [cleanArray addObject:cleanTag];
        }
    }
    return cleanArray;
}

- (BOOL)isVaildBook{
    BOOL hasBookId = (self.bookId && self.bookId.length > 0);
    BOOL hasAuthor = (self.author && self.author.length > 0);
    BOOL hasBookName = (self.bookName && self.bookName.length > 0);
    return (hasAuthor && hasBookId && hasBookName);
}

- (UIColor *)categoryColor{
    NSDictionary *categoryColors = @{
        @"萌宝": [UIColor systemPinkColor],
        @"现代言情": [UIColor systemRedColor],
        @"豪门总裁": [UIColor systemOrangeColor],
        @"游戏动漫": [UIColor systemBlueColor],
        @"都市": [UIColor systemGreenColor]
    };
    return categoryColors[self.category]?:[UIColor systemGrayColor];
}

#pragma mark - 重写部分NSObject方法
- (NSString *)description{
    NSString *newDescription = [NSString stringWithFormat:@"BookModel:\n"
                               @"  📚 书名: %@\n"
                               @"  👤 作者: %@\n"
                               @"  ⭐ 评分: %@\n"
                               @"  📖 分类: %@\n"
                               @"  👥 阅读: %@\n"
                               @"  📝 字数: %@\n"
                               @"  🔖 ID: %@",
                               self.bookName, self.author, self.score,
                               self.category, self.subInfo, [self formattedWordNumber], self.bookId];
    return newDescription;
}

//- (id)copyWithZone:(NSZone *)zone {
//    BookModel *copy = [[BookModel alloc] init];
//    copy.bookId = [self.bookId copy];
//    copy.bookName = [self.bookName copy];
//    copy.author = [self.author copy];
//    copy.abstract = [self.abstract copy];
//    copy.thumbUrl = [self.thumbUrl copy];
//    copy.score = [self.score copy];
//    copy.category = [self.category copy];
//    copy.subInfo = [self.subInfo copy];
//    copy.tags = [self.tags copy];
//    copy.wordNumber = [self.wordNumber copy];
//    copy.chapterNumber = [self.chapterNumber copy];
//    return copy;
//}

@end
