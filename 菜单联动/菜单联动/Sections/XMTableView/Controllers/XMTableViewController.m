//
//  XMTableViewController.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMTableViewController.h"
#import "XMLeftTableCell.h"
#import "XMRightTableCell.h"
#import "MeituanTypeModel.h"
#import "FoodModel.h"
#import "UIImageView+WebCache.h"

@interface XMTableViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *categoryArray;

@end

@implementation XMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TableView 联动";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化数据
    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self leftTableView];
    [self rightTableView];
    
    [self xlTableViewWithResource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)xlTableViewWithResource {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"meituan.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *foods = dic[@"data"][@"food_spu_tags"];
    for (NSDictionary *dic in foods) {
        
        MeituanTypeModel *model = [MeituanTypeModel meituanTypeWithDictionary:dic];
        
        [self.categoryArray addObject:model];
    }
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
    // 默认选择 0 0
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.rightTableView) {
        return self.categoryArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.categoryArray.count;
    }
    else if (tableView == self.rightTableView) {
        return [self.categoryArray[section] spusArray].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        XMLeftTableCell *leftCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMLeftTableCell class]) forIndexPath:indexPath];
        
        MeituanTypeModel *model = self.categoryArray[indexPath.row];
        
        leftCell.typeL.text = model.name;
        
        return leftCell;
    }
    else if (tableView == self.rightTableView) {
        XMRightTableCell *rightCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMRightTableCell class]) forIndexPath:indexPath];
        
        MeituanTypeModel *model = self.categoryArray[indexPath.section];
        FoodModel *foodModel = model.spusArray[indexPath.row];
        
        rightCell.nameL.text = foodModel.name;
        [rightCell.imgView sd_setImageWithURL:[NSURL URLWithString:foodModel.picture] placeholderImage:[UIImage imageNamed:@"Normal"]];
        rightCell.priceL.text = [NSString stringWithFormat:@"￥%@", foodModel.price];
        
        return rightCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightTableView) {
        
        return 30.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.rightTableView == tableView) {
       
    }
    return nil;
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // 当前的tableView是 rightTableView, rightTableView滚动的方向向上, rightTableView是用户拖拽而产生滚动的 ((主要判断rightTableView用户拖拽而滚动的, 还是点击leftTableView而滚动的)
    if (tableView == self.rightTableView && !_isScrollDown && self.rightTableView.dragging) {
        
        [self xlSelectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // 当前的tableView是rightTableView, rightTableView滚动的方向向下, rightTableView是用户拖拽而产生滚动的 ((主要判断rightTableView用户拖拽而滚动的, 还是点击leftTableView而滚动的)
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging) {
        [self xlSelectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.rightTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (tableView == self.leftTableView) {
        _selectIndex = indexPath.row;
        
        [self xlScrollToTopOfSection:_selectIndex animated:YES];
        [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)xlScrollToTopOfSection:(NSInteger)section animated:(BOOL)animated {
    CGRect headerRect = [self.rightTableView rectForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - self.rightTableView.contentInset.top);
    
    [self.rightTableView setContentOffset:topOfHeader animated:animated];
}

// 当拖动右边 TableView 的时候, 处理左边 TableView
- (void)xlSelectRowAtIndexPath:(NSInteger)index {
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

// MARK: - UISrcollViewDelegate

// 标记一下RightTableView的滚动方向, 是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat lastOffsetY = 0;
    UITableView *tableView = (UITableView *) scrollView;
    if (self.rightTableView == tableView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0f, 80.0f, [UIScreen mainScreen].bounds.size.height - 64.0f) style:UITableViewStylePlain];
        
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        _leftTableView.rowHeight = 60.0f; // cell的高度
        
        _leftTableView.showsVerticalScrollIndicator = NO;
        
        [_leftTableView registerClass:[XMLeftTableCell class] forCellReuseIdentifier:NSStringFromClass([XMLeftTableCell class])];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.leftTableView.frame), 64.0f, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(self.leftTableView.frame), CGRectGetHeight(self.leftTableView.frame)) style:UITableViewStylePlain];
        
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        _rightTableView.rowHeight = 80.0f;
        _rightTableView.showsVerticalScrollIndicator = NO;
        
        [_rightTableView registerClass:[XMRightTableCell class] forCellReuseIdentifier:NSStringFromClass([XMRightTableCell class])];
        
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_rightTableView];
        
    }
    return _rightTableView;
}

- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        self.categoryArray = [NSMutableArray new];
    }
    return _categoryArray;
}

@end
