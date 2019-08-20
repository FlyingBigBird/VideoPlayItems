//
//  PlayItemModel.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/26.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "PlayItemModel.h"
#define ADDS(s) [array addObject:s];

@implementation PlayItemModel
- (NSMutableArray *)addVideoData
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *urlStr = @"https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200f660000bcuolispg623e2ujn2o0&line=0&ratio=720p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0";
    NSString *url1 = @"https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc56886e323bbaa8756a147c1d5f70abc8bd28146abe92ac71f5cbf3db3a6e4ee5fa62daea1f19bd8653fdd8bd07687252ee&line=0";
    NSString *url2 = @"https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc561520a4a08fbe6e2907fdc3f245915b98e79ae7b0b3c102f069ca434596644dfe636cf12435757e4e07ed5a730bfedc44&line=0";
    NSString *url3 = @"https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc56382388d87a3f457267bf0938635383936b55ce0a7256108c8bca516394b1e7d9c34b73d8cc06301aaa8729f138805390&line=0";
    NSString *url4 = @"https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc562d3302a4b004cf0f0d68846ad971cfc81cac0d4b52235abb233521174bfff86575292050fa217bc0697ecded717bc918&line=0";
    NSString *u5 = @"https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc568b349139336d7245193ae0aeb69fbe0b66e2b7334bce6d13d8b2017a1e2e03dd9b00ec16013c44ba6d53a0864d6eacc3&line=0";
    NSString *u6 = @"https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc563e163e17dc8cf181fc6806931068022ee4f9af57821957a32787687157e163536180970f24a503a007ef43f0f885fe57&line=0";
    
    
    [array addObject:urlStr];
    [array addObject:url1];
    [array addObject:url2];
    [array addObject:url3];
    [array addObject:url4];
    [array addObject:u5];
    ADDS(u6);
    
    
    return array;
}
@end
