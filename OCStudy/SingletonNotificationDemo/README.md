
# 🏗️ iOS单例模式与通知机制演示Demo

## 📖 项目简介

这是一个纯命令行的iOS学习Demo，演示了**单例模式**和**通知机制**两个重要的设计模式。通过模拟用户管理系统，展示了这两个模式在实际开发中的应用。

## 🎯 学习目标

- 掌握单例模式的标准实现和线程安全
- 理解通知机制的发送、监听和移除
- 学会单例与通知的结合使用
- 了解实际项目中的最佳实践

## 🚀 如何运行

### 方法1：命令行编译
```bash
方法1：命令行编译所有文件
clang -framework Foundation -fobjc-arc \
  Singleton/main.m \
  Singleton/UserManager.m \
  Singleton/BusinessModuleA.m \
  Singleton/BusinessModuleB.m \
  Singleton/NotificationNames.m \
  -o myDemo
方法2：简化命令（编译整个目录）
clang -framework Foundation -fobjc-arc Singleton/*.m -o myDemo
```

### 方法2：Xcode
1. 创建新项目 → macOS → Command Line Tool
2. 将代码复制到main.m
3. 运行项目

## 📋 演示内容

### 1. 单例模式演示
- ✅ 验证同一个实例（地址相同）
- ✅ 线程安全测试（多线程获取同一实例）
- ✅ 全局数据共享

### 2. 通知机制演示
- ✅ 用户登录/退出通知
- ✅ 数据更新通知
- ✅ 多个监听者同时接收通知
- ✅ 通知数据传递（userInfo）

### 3. 实际应用场景
- ✅ 用户状态管理
- ✅ 业务模块解耦通信
- ✅ 资源清理和内存管理

## 🏗️ 代码结构

```
HDC005C25D:SingletonNotificationDemo bytedance$ tree -L 2
.
├── README.md
├── Singleton
│   ├── BusinessModuleA.h
│   ├── BusinessModuleA.m
│   ├── BusinessModuleB.h
│   ├── BusinessModuleB.m
│   ├── main.m
│   ├── NotificationNames.h
│   ├── NotificationNames.m
│   ├── UserManager.h
│   └── UserManager.m
└── Singleton.xcodeproj
    ├── project.pbxproj
    ├── project.xcworkspace
    └── xcuserdata

```

## 🔑 核心知识点

### 单例模式
```objc
// 线程安全的标准写法
+ (instancetype)sharedInstance {
    static UserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserManager alloc] init];
    });
    return instance;
}
```

### 通知机制
```objc
// 发送通知
[[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" 
                                                    object:self 
                                                  userInfo:@{@"key": @"value"}];

// 监听通知
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(handleNotification:) 
                                             name:@"MyNotification" 
                                           object:nil];

// 移除监听（重要！）
[[NSNotificationCenter defaultCenter] removeObserver:self];
```

## 📱 预期输出示例

```
=== 单例模式演示 ===
UserManager单例初始化完成
manager1地址: 0x7f8b1a4061a0
manager2地址: 0x7f8b1a4061a0
是否为同一个实例: 是

=== 通知机制演示 ===
BusinessModuleA 开始监听通知
BusinessModuleB 开始监听通知

--- 测试登录 ---
UserManager: 用户 张三 登录成功
BusinessModuleA 收到登录通知: 用户=张三, token=token_abc123
BusinessModuleB 收到登录通知: 欢迎 张三，开始同步服务器数据

--- 测试数据更新 ---
UserManager: 更新用户资料 {nickname = "小张"; age = 25; city = "北京";}
BusinessModuleA 收到数据更新通知: 类型=userProfile

--- 测试退出登录 ---
UserManager: 用户 张三 退出登录
BusinessModuleA 收到退出通知: 用户=张三
BusinessModuleB 收到退出通知: 再见 张三，停止数据同步
```

## ⚠️ 重要注意事项

1. **线程安全**：单例必须使用`dispatch_once`确保线程安全
2. **通知移除**：对象销毁前必须移除通知监听，避免内存泄漏
3. **通知命名**：使用常量定义通知名称，避免拼写错误
4. **数据传递**：通过`userInfo`传递复杂数据

## 🎓 学习建议

1. **先运行看效果** - 理解输出结果
2. **逐段分析代码** - 理解每个部分的作用
3. **修改参数测试** - 尝试改变用户名、通知数据等
4. **添加新功能** - 尝试添加新的通知类型或监听者
5. **注意内存管理** - 观察通知移除的效果

## 📚 相关概念

- **设计模式**：单例模式、观察者模式
- **iOS基础**：NSNotificationCenter、dispatch_once、NSRunLoop
- **内存管理**：ARC、weak/strong引用
- **多线程**：GCD、线程安全

## 🔗 扩展学习

学完这个Demo后，可以进一步学习：
- KVO（键值观察）
- 代理模式（Delegate）
- MVC架构模式
- 更复杂的多线程应用

---
**创建时间**：2025年学习iOS基础阶段  
**用途**：掌握单例模式和通知机制的核心用法
