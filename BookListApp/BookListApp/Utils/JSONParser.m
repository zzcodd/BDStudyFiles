//
//  JSONParser.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/14.
//

#import "JSONParser.h"

@implementation JSONParser

#pragma mark - 同步解析
+ (NSArray<BookModel *> *)parseBookListFromFile:(NSString *)filename{
    NSLog(@"开始解析书籍列表 : %@.json", filename);
    
    NSDictionary *jsonDict = [self loadJSONFromFile:filename];
    if(!jsonDict) return @[];
    
    // 解析书籍数据路径: data.cell_view.book_data
    NSDictionary *dataDict = jsonDict[@"data"];
    if(![dataDict isKindOfClass:[NSDictionary class]]){
        NSLog(@"JSON格式错误,缺少Data字段");
        return @[];
    }
    NSDictionary *cellViewDict = dataDict[@"cell_view"];
    if(![cellViewDict  isKindOfClass:[NSDictionary class]]){
        NSLog(@"JSON格式错误，缺少cell_view字段");
        return @[];
    }
    NSArray *bookDataArray = cellViewDict[@"book_data"];
    if(![bookDataArray isKindOfClass:[NSArray class]]){
        NSLog(@"JSON格式错误，缺少book_data数组");
    }
    
    NSMutableArray<BookModel *> *books = [NSMutableArray array];
    for(NSDictionary * dict in bookDataArray){
        if([dict isKindOfClass:[NSDictionary class]]){
            BookModel *book = [BookModel bookWithDictionary:dict];
//            NSLog(@"%@",book);
            if(book && [book isVaildBook]){
                [books addObject:book];
            } else {
                NSLog(@"无效书籍数据 %@", dict[@"book_name"]);
            }
        }
    }
    NSLog(@"成功解析 %lu 本书籍", (unsigned long)books.count);
    return [books copy];
}

+ (AdModel *)parseADFromFile:(NSString *)filename{
    NSLog(@"开始解析广告数据 %@.json", filename);
    NSDictionary *jsonDict = [self loadJSONFromFile:filename];
    if(!jsonDict) return nil;
    
    // 解析广告数据路径: ad_item[0]
    NSArray *adItems = jsonDict[@"ad_item"];
    if(![adItems isKindOfClass:[NSArray class]] || adItems.count == 0){
        NSLog(@"JSON格式错误，缺少ad_item数组或者字段为空");
        return nil;
    }
//    NSLog(@"%@ ", adItems);
    
    
    NSDictionary *adDict = adItems[0];
    
    AdModel *ad = [AdModel adWithDictionary:adDict];
    
    if(ad && [ad isVaildAD]){
        NSLog(@"解析广告成功 : %@", ad.title);
    } else {
        NSLog(@"广告数据无效");
        NSLog(@"ad: %@",ad);
        return nil;
    }
    return ad;
}

#pragma mark - 异步解析
+ (void)parseBookListFromFileAsync:(NSString *)filename completion:(void (^)(NSArray<BookModel *> * books, NSError * error))completion{
    if(!completion){
        NSLog(@"回调函数为空");
        return;
    }
    
    // 后台执行解析业务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"后台线程开始解析书籍列表");
        NSArray<BookModel *> *books = [JSONParser parseBookListFromFile:filename];
        
        // 回到主队列进行回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(books.count > 0){
                NSLog(@"主线程回调:解析成功 %lu 本书籍", books.count);
                completion(books,nil);
            } else {
                NSError *error = [NSError errorWithDomain:@"JSONParserError" code:1001 userInfo:@{
                    NSLocalizedDescriptionKey:@"解析书籍列表失败"
                }];
                NSLog(@"主线程回调 ：解析失败");
                completion(books,error);
            }
        });
    });
    
}

+ (void)parseAdFromFileAsync:(NSString *)filename completion:(void (^)(AdModel * ad, NSError * error))completion{
    if(!completion){
        NSLog(@"回调函数为空");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"后台线程开始解析广告信息");
        
        AdModel *ad = [JSONParser parseADFromFile:filename];
       
        // 主进程进行回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(ad){
                NSLog(@"主线程回调：解析广告成功");
                completion(ad, nil);
            } else{
                NSError *error = [NSError errorWithDomain:@"JSONParserError" code:1002 userInfo:@{
                    NSLocalizedDescriptionKey:@"解析广告数据失败"
                }];
                completion(nil, error);
            }
        });
    });
}


#pragma mark - 工具方法
+ (NSString *)pathForJSONFile:(NSString *)filename{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:filename ofType:@"json"];
    
    if(filePath){
        NSLog(@"找到文件路径 : %@", filePath);
    } else {
        NSLog(@"文件不存在 %@.json", filename);
        
        // 帮助调试，读取所有文件
        NSArray *jsonFiles = [mainBundle pathsForResourcesOfType:@"json" inDirectory:nil];
        NSLog(@"Bundle中的JSON文件 : %@", jsonFiles);
    }
    return filePath;
}

+ (BOOL)checkJSONFileExists:(NSString *)filename{
    NSString *path = [self pathForJSONFile:filename];
    return path!=nil;
}

/*
 加载本地JSON文件
 */
+ (NSDictionary *)loadJSONFromFile:(NSString *)filename{
    if(![self checkJSONFileExists:filename]){
        NSLog(@"无法找到该文件 %@", filename);
        return nil;
    }
    
    NSString *filepath = [self pathForJSONFile:filename];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    if(!data){
        NSLog(@"无法读取文件内容 %@", filename);
        return nil;
    }
    NSLog(@"文件读取成功 %lu 字节", data.length);
    
    NSError * error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error){
        NSLog(@"JSON解析错误 %@", error.localizedDescription);
        return nil;
    }
    NSLog(@"JSON解析成功");
    return dict;
}


+ (void)printParsingStatistics{
    NSLog(@"JSON解析统计:");
    
    BOOL bookFileExists = [self checkJSONFileExists:@"book_list"];
    NSLog(@"book_list.json %@", bookFileExists?@"存在":@"不存在");
    
    BOOL adFileExists = [self checkJSONFileExists:@"作业横版视频"];
    NSLog(@"作业横版视频.json %@", adFileExists?@"存在":@"不存在");
    
    if(bookFileExists){
        NSArray *books = [JSONParser parseBookListFromFile:@"book_list"];
        NSLog(@"可解析书籍数量: %lu", (unsigned long)books.count);
    }
    
    if(adFileExists){
        AdModel *ad = [JSONParser parseADFromFile:@"作业横版视频"];
        NSLog(@"广告解析状态: %@", ad ? @"成功" : @"失败");
    }
}

@end
