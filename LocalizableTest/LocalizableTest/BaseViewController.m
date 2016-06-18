//
//  BaseViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/13.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseViewController () <UIActionSheetDelegate,WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) NSURL *homeUrl;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic, copy) NSString *applicationNameForUserAgent;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"WebView";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    @"https://www.baidu.com"
    self.homeUrl = [NSURL URLWithString:@"https://www.baidu.com"];
    //    @"http://192.168.1.40:8080/www/test.html"];
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    
    // 进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.progressView.tintColor = [UIColor colorWithRed:0.80 green:0 blue:0 alpha:1];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    
    
    //设置userAgent
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = [userAgent stringByAppendingFormat:@" %@ Language/%@", @"Dajialai/1.0", [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"][0]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.configuration.allowsInlineMediaPlayback = YES;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.homeUrl]];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, 100, 40);
    label.backgroundColor = [UIColor redColor];
    [self.webView insertSubview:label belowSubview:self.webView.scrollView];

}

- (void)configColseItem {
    // 导航栏的关闭按钮
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(colseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [newArr addObject:colseItem];;
    self.navigationItem.leftBarButtonItems = newArr;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.webView.canGoBack) {
        if (self.navigationItem.leftBarButtonItems.count == 2) {
            [self configColseItem];
        }
    }
    return YES;
}

// 返回按钮点击
- (void)backBtnPressed:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        if (self.navigationItem.leftBarButtonItems.count == 2) {
            [self configColseItem];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 关闭按钮点击
- (void)colseBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:newprogress animated:YES];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)dismiss {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0 animated:NO];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self setTitle:navigationAction.request.URL.host];
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
