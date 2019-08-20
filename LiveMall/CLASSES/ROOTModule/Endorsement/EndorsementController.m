//
//  EndorsementController.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "EndorsementController.h"
#import "PreviewController.h"

@interface EndorsementController ()

@end

@implementation EndorsementController

- (void)viewDidLoad {
    [super viewDidLoad];


    //双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapSel)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalTapSel)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    //双击失败之后执行单击
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];


}
- (void)doubleTapSel
{
    
    NSURL * url2 = [NSURL URLWithString:@"alipay://platformapi/startapp?saId=20001003"];
    [[UIApplication sharedApplication] openURL:url2];

}
- (void)signalTapSel
{
    PreviewController *preVC = [[PreviewController alloc] init];
    [self.navigationController pushViewController:preVC animated:YES];
    
//    // 是否支持支付宝
//    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay://"];
//
//    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
//
//
//        NSURL * url = [NSURL URLWithString:@"alipay://platformapi/startapp?saId=20000085"];
//        [[UIApplication sharedApplication] openURL:url];
//    }
    
}
/*
 扫一扫
 alipay://platformapi/startapp?saId=10000007"

 付款码
 alipay://platformapi/startapp?saId=20000056

 支付宝卡包
 alipayqr://platformapi/startapp?saId=20000021
 （跳转支付宝卡包页面）
 
 支付宝吱口令
 alipayqr://platformapi/startapp?saId=20000085
 （跳转支付宝吱口令页面）
 
 支付宝芝麻信用
 alipayqr://platformapi/startapp?saId=20000118
 （跳转支付宝芝麻信用页面）
 
 支付宝红包
 alipayqr://platformapi/startapp?saId=88886666
 （跳转支付宝红包页面）
 
 支付宝爱心
 alipayqr://platformapi/startapp?saId=1000009
 （跳转支付宝献爱心页面）
 
 支付宝升级页面
 alipayqr://platformapi/startapp?saId=2000066
 （跳转支付宝升级页面）
 
 支付宝滴滴打的
 alipayqr://platformapi/startapp?saId=2000130
 （跳转支付宝滴滴打的页面）
 
 支付宝客服
 alipayqr://platformapi/startapp?saId=2000691
 （跳转支付宝客服页面）
 
 支付宝生活
 alipayqr://platformapi/startapp?saId=2000193
 （跳转支付宝生活页面）
 
 支付宝生活号
 alipayqr://platformapi/startapp?saId=2000101
 （跳转支付宝生活号页面）
 
 支付宝记账
 alipayqr://platformapi/startapp?saId=2000168
 （跳转支付宝记账页面）
 */

@end
