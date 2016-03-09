//
//  HomeViewController.m
//  美团HD
//
//  Created by Tengfei on 16/1/7.
//  Copyright © 2016年 tengfei. All rights reserved.
//

#import "HomeViewController.h"
#import "TFConst.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "TFHomeTopItem.h"
#import "TFHomeDropdown.h"
#import "CategoryController.h"
#import "TFReginViewController.h"
#import "TFMetaTool.h"
#import "TFCity.h"
#import "TFSortViewController.h"
#import "TFSort.h"
#import "TFCategory.h"
#import "TFregion.h"
//#import "DPAPI.h"
#import "MJExtension.h"
//#import "TFDeal.h"
//#import "MTDealCell.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "BaseNavigationController.h"
#import "TFSearchViewController.h"
#import "AwesomeMenu.h"
#import "UIView+AutoLayout.h"
#import "TFCollectViewController.h"
#import "TFRecentViewController.h"


@interface HomeViewController ()<AwesomeMenuDelegate>
/**
 *  分类item
 */
@property (nonatomic,weak)UIBarButtonItem * categoryItem;
/**
 *  区域item
 */
@property (nonatomic,weak)UIBarButtonItem * districtItem;
/**
 *  排序item
 */
@property (nonatomic,weak)UIBarButtonItem * sortItem;

/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的分类的名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的排序的名字 */
@property (nonatomic, strong) TFSort *selectedSort;
/** 当前选中的区域的名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/**
 *  分类popover
 */
@property (nonatomic,strong)UIPopoverController * categoryPopover;
/**
 *  区域popover
 */
@property (nonatomic,strong)UIPopoverController * regionPopover;
/**
 *  排序popover
 */
@property (nonatomic,strong)UIPopoverController * sortPopover;
@end

@implementation HomeViewController


/**
    //tableview
 *  self.view == self.tableview
    //collectionView
    self.view == self.collectionView.superview
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self setupNotifications];
    
    //设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
    
    //创建awesomeMenu
    [self setupAwesomeMenu];
}

- (void)setupAwesomeMenu
{
    // 1.中间的item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    
    // 2.周边的item
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    NSArray *items = @[item0, item1, item2, item3];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    menu.alpha = 0.5;
    // 设置菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    // 设置开始按钮的位置
    menu.startPoint = CGPointMake(50, 150);
    // 设置代理
    menu.delegate = self;
    // 不要旋转中间按钮
    menu.rotateAddButton = NO;
    [self.view addSubview:menu];
    
    // 设置菜单永远在左下角
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}

-(void)setupNotifications
{
    //监听城市选择的通知
    [TFNotificationCenter addObserver:self selector:@selector(cityChage:) name:TFCityDidSelectNotification object:nil];
    
    //监听排序改变
    [TFNotificationCenter addObserver:self selector:@selector(sortChage:) name:TFSortDidSelectNotification object:nil];
    
    //监听排序改变
    [TFNotificationCenter addObserver:self selector:@selector(categoryChage:) name:TFCategoryDidSelectNotification object:nil];
    
    //监听区域改变
    [TFNotificationCenter addObserver:self selector:@selector(regionChage:) name:TFReginDidSelectNotification object:nil];
}

-(void)setupLeftNav
{
    //1.logol
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logo.enabled = NO;
    
    //2.
    TFHomeTopItem *categoryItem = [TFHomeTopItem item];
    [categoryItem addTaget:self action:@selector(categoryClick)];
    UIBarButtonItem *category = [[UIBarButtonItem alloc]initWithCustomView:categoryItem];
    self.categoryItem = category;

    //3.
    TFHomeTopItem *districItem = [TFHomeTopItem item];
    [districItem addTaget:self action:@selector(districtClick)];
    UIBarButtonItem *distric = [[UIBarButtonItem alloc]initWithCustomView:districItem];
    self.districtItem = distric;
    
    //4.
    TFHomeTopItem *sortItem = [TFHomeTopItem item];
    sortItem.title = @"排序";
    [sortItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortItem addTaget:self action:@selector(sortClick)];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc]initWithCustomView:sortItem];
    self.sortItem = sort;
    
    self.navigationItem.leftBarButtonItems = @[logo,category,distric,sort];
}

-(void)setupRightNav
{
    UIBarButtonItem *map = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
    map.customView.width = 60;
    
    UIBarButtonItem *search = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"icon_search" highImage:@"icon_search_highlighted"];
    search.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[map, search];
}
#pragma mark - 顶部item的点击方法

#pragma mark - 点击搜索按钮
- (void)search
{
    if (self.selectedCityName) {
        TFSearchViewController *search = [[TFSearchViewController alloc] init];
        search.cityName = self.selectedCityName;
        BaseNavigationController  *nav = [[BaseNavigationController alloc] initWithRootViewController:search];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"请选择城市后进行搜索" toView:self.view];
    }
}

-(void)categoryClick
{
//    NSLog(@"categoryClick");
    //
    CategoryController *cate = [[CategoryController alloc]init];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:cate];
    popover.popoverContentSize = CGSizeMake(360, 500);
    self.categoryPopover = popover;
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//区域
-(void)districtClick
{
    TFReginViewController *cate = [[TFReginViewController alloc]init];
    //获取当前选中城市的区域
    NSLog(@"--:selectedCityName:%@",self.selectedCityName);
    if (self.selectedCityName) {
//MTCity *city = [[[MTMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName]] firstObject];
        NSArray *array = [[TFMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]] ;
        TFCity *city = [array firstObject];
        cate.regions = city.regions;
    }
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:cate];
    popover.popoverContentSize = CGSizeMake(300, 500);
     self.regionPopover = popover;
    [popover presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
//排序
-(void)sortClick
{
    TFSortViewController *sort = [[TFSortViewController alloc]init];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:sort];
//    popover.popoverContentSize = CGSizeMake(300, 500);
     self.sortPopover = popover;
    [popover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 监听城市改变
-(void)cityChage:(NSNotification *)notification
{
    self.selectedCityName = notification.userInfo[TFSelectCityName];
//    NSLog(@"城市名字改变:%@",cityName);
    
    //1-更换听不区域item的文字
   TFHomeTopItem *topItem = (TFHomeTopItem *)self.districtItem.customView;
//    self.selectedCityName = cityName;
    topItem.title = [NSString stringWithFormat:@"%@ - 全部",self.selectedCityName];
    topItem.subTitle = nil;
    
    [self.regionPopover dismissPopoverAnimated:YES];
    
    //2-刷新表格数据
#warning TODO 
//    [self loadNewDeals];
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 监听排序改变
-(void)sortChage:(NSNotification *)notification
{
    TFSort *sort = notification.userInfo[TFSelectSortName];
    self.selectedSort = sort;
    //1-更换听不区域item的文字
    TFHomeTopItem *topItem = (TFHomeTopItem *)self.sortItem.customView;
    topItem.subTitle = sort.label;
    
    //2-刷新表格数据
#warning TODO
    //    [self loadNewDeals];
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 分类排序改变
-(void)categoryChage:(NSNotification *)notification
{
    TFCategory *category = notification.userInfo[TFSelectCategoryName];
    NSString *subCategory = notification.userInfo[TFSelectSubCategoryName];
    
    if (subCategory == nil) {
        self.selectedCategoryName = category.name;
    }else{
        self.selectedCategoryName = [subCategory isEqualToString:@"全部"] ? category.name : subCategory;
    }
    
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    //1-更换分类item的文字
    TFHomeTopItem *topItem = (TFHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    topItem.title = category.name;
    topItem.subTitle = subCategory ? subCategory : @"全部";
    //关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    //2-刷新表格数据
#warning TODO
    //    [self loadNewDeals];
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 区域改变
-(void)regionChage:(NSNotification *)notification
{
    TFregion  *region = notification.userInfo[TFSelectReginName];
    NSString *subRegion = notification.userInfo[TFSelectSubReginName];
    
    if (subRegion == nil || [subRegion isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    }else{
        self.selectedRegionName = subRegion;
    }
    
    if ([self.selectedRegionName isEqualToString:@"全部分类"]) {
        self.selectedRegionName = nil;
    }
    
    //1-更换分类item的文字
    TFHomeTopItem *topItem = (TFHomeTopItem *)self.districtItem.customView;
//    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    topItem.title = [NSString stringWithFormat:@"%@ - %@",self.selectedCityName,region.name];
    topItem.subTitle = subRegion ? subRegion : @"全部";
    //关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    //2-刷新表格数据
#warning TODO
    //    [self loadNewDeals];
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 实现父类提供的方法
- (void)setupParams:(NSMutableDictionary *)params
{
    params[@"city"] = self.selectedCityName;
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
}



#pragma mark - AwesomeMenuDelegate
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    // 替换菜单的图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    
    // 完全显示
    menu.alpha = 1.0;
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    // 替换菜单的图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    
    // 半透明显示
    menu.alpha = 0.5;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    // 替换菜单的图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];

    switch (idx) {
        case 0: { // 收藏
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[[TFCollectViewController alloc] init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
            
        case 1: { // 最近访问记录
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[[TFRecentViewController alloc] init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}


-(void)dealloc
{
    [TFNotificationCenter removeObserver:self];
}

#pragma mark <UICollectionViewDelegate>



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com