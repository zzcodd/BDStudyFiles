//
//  WebViewController.h
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController<WKNavigationDelegate>
@property(nonatomic, strong) WKWebView* webView;
@end

NS_ASSUME_NONNULL_END
