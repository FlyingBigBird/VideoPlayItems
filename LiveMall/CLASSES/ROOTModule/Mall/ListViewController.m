//
//  ListViewController.m
//  XLBasePage
//
//  Created by BaoBaoDaRen on 2019/6/19.
//  Copyright © 2019 ZXL. All rights reserved.
//

#import "ListViewController.h"
#import "BasicTextView.h"

#define COLOR_WITH_RGB(R,G,B,A) [UIColor colorWithRed:R green:G blue:B alpha:A]

@interface ListViewController () 

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_WITH_RGB(arc4random()%255/255.0, arc4random()%255/255.0, arc4random()%255/255.0, 1);
    
//    BasicTextView *textV = [[BasicTextView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:textV];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    
    return self.view;
}

- (void)listDidAppear {
    
}

- (void)listDidDisappear {
    
}






@end
