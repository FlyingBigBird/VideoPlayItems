//
//  BasicTabController.m
//  LiveMall
//
//  Created by BaoBaoDaRen on 2019/6/20.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "BasicTabController.h"
#import "TabBarView.h"
#import "HomePageController.h"
#import "EndorsementController.h"
#import "ShopCenterController.h"
#import "MyShopStoreController.h"
#import "MyInfoCenterController.h"

@interface BasicTabController () <TabBarViewDelegate>

@property (nonatomic, strong) UIView                    * containerView;

@property (nonatomic, strong) NSArray                   * getControllerArray;
@property (nonatomic, assign) NSInteger                 currenSelectedIndex;
@property (nonatomic, strong) NSMutableArray            * rootArray;

@property (nonatomic, strong) HomePageController        * homeVC;
@property (nonatomic, strong) EndorsementController     * endorVC;
@property (nonatomic, strong) ShopCenterController      * shopVC;
@property (nonatomic, strong) MyShopStoreController     * myShopVC;
@property (nonatomic, strong) MyInfoCenterController    * myInfoVC;

@end

@implementation BasicTabController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;

    [self barItemInit];


}
- (void)barItemInit
{
    UIColor * selectedTitleColor = [UIColor colorWithHexString:@"#272727"];
    UIColor * unSelectedTitleColor = [UIColor colorWithHexString:@"#929292"];
    UIColor * backColor = [UIColor whiteColor];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.containerView];
    
    self.homeVC   = [[HomePageController alloc] init];
    self.endorVC  = [[EndorsementController alloc] init];
    self.shopVC   = [[ShopCenterController alloc] init];
    self.myShopVC = [[MyShopStoreController alloc] init];
    self.myInfoVC = [[MyInfoCenterController alloc] init];

    NSArray * controllerArray = @[_homeVC, _endorVC, _shopVC, _myShopVC, _myInfoVC];
    
    self.getControllerArray = [NSArray array];
    self.getControllerArray = controllerArray;
    
    self.rootArray = [NSMutableArray array];
    for (int i = 0; i < controllerArray.count; i++)
    {
        [_rootArray addObject:controllerArray[i]];
    }
    
    // 获取到需要控制器的数组...
    for (int i = 0; i < _rootArray.count; i++)
    {
        UIViewController * rootController = (UIViewController *)(_rootArray[i]);
        
        [self addChildViewController:rootController];
        if (i == 0)
        {
            self.currentViewController = rootController;
            [self.containerView addSubview:rootController.view];
        }
    }
    
    TabBarView * tabBarItem = [[TabBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TabBar_H, SCREEN_WIDTH, TabBar_H)];
    [self.view addSubview:tabBarItem];
    
    self.currenSelectedIndex = 0;
    
    NSArray * titleArray = @[@"发现", @"代言", @"商城", @"我的纷店",@"我的"];
    UIImage * centerImage = [UIImage imageNamed:@""];
    
    NSArray * selectedImageArray = @[[UIImage imageNamed:@"gongdan2"],[UIImage imageNamed:@"peijian2"],[UIImage imageNamed:@"zhishiku2"],[UIImage imageNamed:@"wode2"],[UIImage imageNamed:@"wode2"]];
    NSArray * unSelectedImageArray = @[[UIImage imageNamed:@"gongdan1"],[UIImage imageNamed:@"peijian1"],[UIImage imageNamed:@"zhishiku1"],[UIImage imageNamed:@"wode1"],[UIImage imageNamed:@"wode1"]];
    
    [tabBarItem customTabBarItemNumber:titleArray.count withCenterLarge:NO withTitleArray:titleArray withSelectedImageArray:selectedImageArray withUnSelectedImageArray:unSelectedImageArray withCenterImage:centerImage withBackGroundColor:backColor withTitleSelectColor:selectedTitleColor withTitleUnSelectColor:unSelectedTitleColor];
    tabBarItem.delegate = self;
    
    [tabBarItem setCustomTabBarSelectedIndex:self.currenSelectedIndex];

}
#pragma mark - TabBarViewDelegate
- (void)tabBarItemDidSelectAtIndex:(NSInteger)selectedIndex
{
    self.homeVC   = self.childViewControllers[0];
    self.endorVC  = self.childViewControllers[1];
    self.shopVC   = self.childViewControllers[2];
    self.myShopVC = self.childViewControllers[3];
    self.myInfoVC = self.childViewControllers[4];
    if (! ((self.currentViewController    ==  _homeVC   && (selectedIndex == 0))
          || (self.currentViewController  ==  _endorVC  && (selectedIndex == 1))
          || (self.currentViewController  ==  _shopVC   && (selectedIndex == 2))
          || (self.currentViewController  ==  _myShopVC && (selectedIndex == 3))
          || (self.currentViewController  ==  _myInfoVC && (selectedIndex == 4))))
    {
        UIViewController * previousViewController = self.currentViewController;
        
        switch (selectedIndex)
        {
            case 0:
            {
                [self transitionFromViewController:self.currentViewController toViewController:self.homeVC duration:0.3f options:UIViewAnimationOptionTransitionNone animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    if (finished)
                    {
                        self.currentViewController = self.homeVC;
                    } else
                    {
                        self.currentViewController = previousViewController;
                    }
                }];
                
                break;
            }
            case 1:
            {
                [self transitionFromViewController:self.currentViewController toViewController:self.endorVC duration:0.3f options:UIViewAnimationOptionTransitionNone animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    if (finished)
                    {
                        self.currentViewController = self.endorVC;
                    } else
                    {
                        self.currentViewController = previousViewController;
                    }
                }];
                
                break;
            }
            case 2:
            {
                [self transitionFromViewController:self.currentViewController toViewController:self.shopVC duration:0.3f options:UIViewAnimationOptionTransitionNone animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    if (finished)
                    {
                        self.currentViewController = self.shopVC;
                    } else
                    {
                        self.currentViewController = previousViewController;
                    }
                }];
                
                break;
            }
            case 3:
            {
                [self transitionFromViewController:self.currentViewController toViewController:self.myShopVC duration:0.3f options:UIViewAnimationOptionTransitionNone animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    if (finished)
                    {
                        self.currentViewController = self.myShopVC;
                    } else
                    {
                        self.currentViewController = previousViewController;
                    }
                }];
                break;
            }
            case 4:
            {
                [self transitionFromViewController:self.currentViewController toViewController:self.myInfoVC duration:0.3f options:UIViewAnimationOptionTransitionNone animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    if (finished)
                    {
                        self.currentViewController = self.myInfoVC;
                    } else
                    {
                        self.currentViewController = previousViewController;
                    }
                }];
                break;
            }
            default:
                break;
        }
    }
}

/**
 *  方法说明：
 *  1、addChildViewController:向父VC中添加子VC，添加之后自动调用willMoveToParentViewController:父VC
 *  2、removeFromParentViewController:将子VC从父VC中移除，移除之后自动调用didMoveToParentViewController:nil
 *  3、willMoveToParentViewController:  当向父VC添加子VC之后，该方法会自动调用。若要从父VC移除子VC，需要在移除之前调用该方法，传入参数nil。
 *  4、didMoveToParentViewController:  当向父VC添加子VC之后，该方法不会被自动调用，需要显示调用告诉编译器已经完成添加; 从父VC移除子VC之后，该方法会自动调用，传入的参数为nil,所以不需要显示调用。
 */

/**
 *  注意点：
 要想切换子视图控制器a/b,a/b必须均已添加到父视图控制器中，不然会报错
 */


@end
