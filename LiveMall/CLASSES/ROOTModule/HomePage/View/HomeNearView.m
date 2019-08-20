//
//  HomeNearView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "HomeNearView.h"

@implementation HomeNearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHomeNearViewSubs:frame];
    }
    return self;
}

- (void)setHomeNearViewSubs:(CGRect)supframe
{
    self.backgroundColor = [UIColor blueColor];
}


@end
