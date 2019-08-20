//
//  BasicTextView.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/28.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "BasicTextView.h"
#import "TopAlertView.h"

@interface BasicTextView () <UITextViewDelegate>
{
    CGFloat font;
}
@property (nonatomic, strong) TopAlertView *alerV;
@property (nonatomic, assign) BOOL proSelected;

@end

@implementation BasicTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBasicTextViewSubs];
    }
    return self;
}

- (void)setBasicTextViewSubs
{
    font = 18;
    
    self.editable = NO;
    self.scrollEnabled = YES;
    self.delegate = self;
    
    UIMenuItem *copy = [[UIMenuItem alloc]initWithTitle:@"拷贝" action:@selector(doMenuItemTarget:)];
    UIMenuItem *paste = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(doMenuItemTarget:)];
    UIMenuItem *translate = [[UIMenuItem alloc]initWithTitle:@"翻译" action:@selector(doMenuItemTarget:)];
    UIMenuItem *share = [[UIMenuItem alloc]initWithTitle:@"分享" action:@selector(doMenuItemTarget:)];

    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:@[copy,paste,translate,share]];
    [menuController setMenuVisible:NO];

    [self protocolSelected:self.proSelected];
}

- (void)protocolSelected:(BOOL)select {
    
    NSString *nameStr = @"欧雷瓦";
    NSString *proStr = @"腾讯游戏使用学及服务协议";
    NSString *privateStr = @"隐私保护指引";
    NSString *protocolInfo = [NSString stringWithFormat:@"%@ 已经详细阅读并同意 %@ 和 %@",nameStr,proStr,privateStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:protocolInfo];
    [attStr addAttribute:NSLinkAttributeName
                             value:@"name://"
                             range:[protocolInfo rangeOfString:nameStr]];
    [attStr addAttribute:NSLinkAttributeName
                             value:@"protocol://"
                             range:[protocolInfo rangeOfString:proStr]];
    [attStr addAttribute:NSLinkAttributeName
                             value:@"private://"
                             range:[protocolInfo rangeOfString:privateStr]];
    
    
    UIImage *image = [UIImage imageNamed:select == YES ? @"icon_personal_add_little" : @"football"];
    
    
    NS_ASSUME_NONNULL_BEGIN
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [self drawSelectdImage:image];
    NSMutableAttributedString *imageString = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
    NS_ASSUME_NONNULL_END

    [imageString addAttribute:NSLinkAttributeName
                        value:@"selected://"
                        range:NSMakeRange(0, imageString.length)];
    [attStr insertAttributedString:imageString atIndex:0];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:[protocolInfo rangeOfString:protocolInfo]];
    
    self.attributedText = attStr;
    self.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                     NSUnderlineColorAttributeName: [UIColor greenColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    
}
- (UIImage *)drawSelectdImage:(UIImage *)image
{
    CGSize size = CGSizeMake(font + 2, font + 2);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [image drawInRect:CGRectMake(0, 2, size.width, size.height)];
    UIImage *drawImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return drawImage;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    NSString *scheme = [URL scheme];
    
    if ([scheme containsString:@"name"]) {
        
        [self showAlertInfo:@"点我干啥" inView:nil];
    } else if ([scheme containsString:@"protocol"]) {
        
        [self showAlertInfo:@"点了腾讯游戏使用学及服务协议" inView:nil];
    } else if ([scheme containsString:@"private"]){
     
        [self showAlertInfo:@"点了隐私保护指引" inView:nil];
    } else if  ([scheme containsString:@"selected"]){
        
        self.proSelected = !self.proSelected;
        [self protocolSelected:self.proSelected];
    }
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    if (action == @selector(doMenuItemTarget:)) {
        return YES;
    }
    return NO;
}
- (void)doMenuItemTarget:(UIMenuItem *)item{
    
    [self showAlertInfo:@"自定义响应内容" inView:nil];
}
- (void)showAlertInfo:(NSString *)title inView:(UIView *)view
{
    // 搜索...
    TopAlertView *alert = [[TopAlertView alloc] initWithImage:[UIImage imageNamed:@"football"] title:title superView:view];
    [alert rightBarItemImage:[UIImage imageNamed:@"football"] finished:^{
        
        
    }];
    [alert showWithAnimation:YES];
}


@end


