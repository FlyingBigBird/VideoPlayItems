//
//  LYHttpRequest.h
//  FotileCSS
//
//  Created by baobao on 16/08/31.
//  Copyright (c) 2016年 baobao. All rights reserved.
//

#import "LYHttpRequest.h"

@implementation LYHttpRequest

+(void)requestWithUrlString:(NSString *)urlString parm:(id)dic finished:(AFFinishedBlock)finshedBlock failed:(AFFailedBlock)failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置一个不指定数据返回格式的serializer对象,这样会将NSData的数据返回给我们
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
//    [manager.requestSerializer setValue:@"token"] forHTTPHeaderField:@"Authorization"];
    
    /**
     *  允许使用自签名的不安全的证书...
     */
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    //也不验证域名一致性
    //    manager.securityPolicy.validatesDomainName = NO;
    //    //关闭缓存避免干扰测试
    //    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    /**
     *  测试结束必须关闭此功能保证安全性...
     */
    
    if (dic) {
        
        //post
        __weak typeof (finshedBlock)weakfinshedBlock = finshedBlock;
        __weak typeof (failedBlock)weakfailedBlock = failedBlock;
        
        [manager POST:urlString parameters:dic progress:nil success:weakfinshedBlock failure:weakfailedBlock];
        //        [manager POST:urlString parameters:dic success:finshedBlock failure:failedBlock];
    } else {
        
        //get ,需要接收两个block，我们可以传匿名函数，也可以传block变量
        [manager GET:urlString parameters:dic progress:nil success:finshedBlock failure:failedBlock];
        //        [manager GET:urlString parameters:nil success:finshedBlock failure:failedBlock];
        //            [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        //
        //                ///写一些逻辑，再将自己定义的block传出
        //
        //
        //            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        //
        //            }];
    }
}

@end
