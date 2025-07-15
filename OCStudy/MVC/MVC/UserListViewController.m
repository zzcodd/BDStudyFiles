//
//  UserListViewController.m
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import "UserListViewController.h"
#import "UserManager.h"
#import "UserableViewCell.h"
#import "User.h"


@interface UserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<User *> *users;
@property (nonatomic, strong) UserManager *userManager;

@end

@implementation UserListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self setupUI];
    [self setupData];
    [self loadUsers];
}

- (void)setupUI {
    self.title = @"用户列表";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // 设置导航栏按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUserButtonTapped)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // 配置TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    
    // 注册Cell
    [self.tableView registerClass:[UserableViewCell class] forCellReuseIdentifier:@"UserCell"];
}

- (void)setupData {
    self.userManager = [UserManager sharedManager];
}

- (void)loadUsers {
    // 从Model层获取数据
    self.users = [self.userManager getAllUsers];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)addUserButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加用户" message:@"请输入用户信息" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"姓名";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"邮箱";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"年龄";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleAddUserWithName:alert.textFields[0].text
                              email:alert.textFields[1].text
                                age:alert.textFields[2].text];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:addAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleAddUserWithName:(NSString *)name email:(NSString *)email age:(NSString *)ageString {
    // 数据验证
    if (name.length == 0) {
        [self showAlertWithTitle:@"错误" message:@"姓名不能为空"];
        return;
    }
    
    if (email.length == 0) {
        [self showAlertWithTitle:@"错误" message:@"邮箱不能为空"];
        return;
    }
    
    NSInteger age = [ageString integerValue];
    if (age <= 0 || age > 120) {
        [self showAlertWithTitle:@"错误" message:@"请输入有效的年龄"];
        return;
    }
    
    // 创建用户对象
    User *newUser = [[User alloc] initWithName:name email:email age:age];
    
    // 验证邮箱格式
    if (![newUser isValidEmail]) {
        [self showAlertWithTitle:@"错误" message:@"邮箱格式不正确"];
        return;
    }
    
    // 添加到Model
    [self.userManager addUser:newUser];
    
    // 刷新View
    [self loadUsers];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    User *user = self.users[indexPath.row];
    [cell configureWithUser:user];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *selectedUser = self.users[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户详情"
                                                                  message:[selectedUser description]
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *userToDelete = self.users[indexPath.row];
        
        // 从Model中删除
        [self.userManager removeUser:userToDelete];
        
        // 刷新View
        [self loadUsers];
    }
}

@end
