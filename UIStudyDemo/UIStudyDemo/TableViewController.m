//
//  TableViewController.m
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import "TableViewController.h"
#import "DetailViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"📋 TableViewController加载，演示UITableView和UITableViewCell");

    self.dataSource = @[
        @"📱 iPhone 15 Pro",
        @"💻 MacBook Pro",
        @"⌚ Apple Watch",
        @"🎧 AirPods Pro",
        @"📺 Apple TV",
        @"🖥️ iMac",
        @"📱 iPad Pro",
        @"🖱️ Magic Mouse",
        @"⌨️ Magic Keyboard",
        @"🔌 MagSafe充电器",
    ];
    
    [self setupTableView];
    [self addInfoLabel];
}

-(void)setupTableView{
    // 创建UITableView
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
    // 设置数据源和代理
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    // 注册cell类
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableview.frame = CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height-180);
    
    [self.view addSubview:self.tableview];
    NSLog(@"📋 UITableView创建完成，注册了Cell复用标识符");

}

-(void)addInfoLabel{
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"UITableView演示\n下面是UITableViewCell列表\n点击任意cell查看详情";
    infoLabel.numberOfLines = 3;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor systemBlueColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.frame = CGRectMake(0, 100, self.view.bounds.size.width, 80);
    [self.view addSubview:infoLabel];
}

#pragma mark - 🔥 UITableViewDataSource（数据源方法）
// 告诉tableView有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"📊 tableView询问：有多少行数据？答：%lu行", self.dataSource.count);
    return self.dataSource.count;
}

// 告诉tableView每一行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 复用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"🔧 创建第%ld行的UITableViewCell：%@", indexPath.row, self.dataSource[indexPath.row]);
    return cell;
}

#pragma mark - 🔥 UITableViewDelegate（代理方法）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // 设置选中块是否有高亮 animated表示是否有动画过渡
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedItem = self.dataSource[indexPath.row];
    NSLog(@"👆 用户点击了第%ld行：%@", indexPath.row, selectedItem);
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.title = selectedItem;
    detailVC.selectedItem = selectedItem;

    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
