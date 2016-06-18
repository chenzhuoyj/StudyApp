//
//  ApplePayViewController.m
//  LocalizableTest
//
//  Created by cz on 16/6/17.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "ApplePayViewController.h"
#import <PassKit/PassKit.h>

@interface ApplePayViewController () <PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ApplePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Apple Pay";
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initViews {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Apple Pay" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(applePay) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = CGPointMake(self.view.center.x, self.view.center.y);
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1].CGColor;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    
}

- (void)applePay {
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        //指定国家地区编码
        request.countryCode = @"CN";
        //指定国家货币种类--人民币
        request.currencyCode = @"CNY";
        //指定支持的网上银行支付方式
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay, PKPaymentNetworkDiscover, PKPaymentNetworkInterac, PKPaymentNetworkMasterCard, PKPaymentNetworkPrivateLabel];
        //指定支付的范围限制
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        //指定订单接受的地址是哪里
//        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        //指定APP需要的商业ID
        request.merchantIdentifier = @"merchant.com.dajialai.troy";
        
        //商品订单信息对象
        PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"宝马车一辆" amount:[NSDecimalNumber decimalNumberWithString:@"688000.00"]];
        PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"折扣" amount:[NSDecimalNumber decimalNumberWithString:@"-687999.99"]];
        PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"CZ" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        request.paymentSummaryItems = @[item1,item2,item3];
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        if (!paymentPane) {
            NSLog(@"出问题了，请注意检查");
            @throw  [NSException exceptionWithName:@"CQ_Error" reason:@"创建支付显示界面不成功" userInfo:nil];
        } else {
            [self presentViewController:paymentPane animated:YES completion:nil];
        }
    }
}

//在支付的过程中进行调用，这个方法直接影响支付结果在界面上的显示
//payment 是代表的支付对象，支付相关的所有信息都存在于这个对象,1 token 2 address
//comletion 是一个回调Block块，block块传递的参数直接影响界面结果的显示。
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
        
    //拿到token，
    PKPaymentToken *token = payment.token;
    //拿到订单地址
    NSString *city = payment.billingContact.postalAddress.city;
    NSLog(@"city # %@ token # %@",city, token);
    ///在这里将token和地址发送到自己的服务器，有自己的服务器与银行和商家进行接口调用和支付将结果返回到这里
    //我们根据结果生成对应的状态对象，根据状态对象显示不同的支付结构
    //状态对象
    PKPaymentAuthorizationStatus status = PKPaymentAuthorizationStatusSuccess;
    completion(status);
}

//当支付过程完成的时候进行调用
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
