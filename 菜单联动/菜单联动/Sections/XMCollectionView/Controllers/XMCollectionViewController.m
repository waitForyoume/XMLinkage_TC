//
//  XMCollectionViewController.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMCollectionViewController.h"
#import "UIView+XMAdd.h"
#import "XMLeftTableCell.h"
#import "LiwushuoModel.h"
#import "GiftModel.h"
#import "XMRightCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "XMGiftReusableView.h"
#import "XMCollectionViewFlowLayout.h"

@interface XMCollectionViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

{
    NSInteger _isSelectIndex;
    BOOL _isScrollDown;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, strong) XMCollectionViewFlowLayout *flowLayout;

@end

@implementation XMCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CollectionView 联动";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化数据
    _isSelectIndex = 0;
    _isScrollDown = YES;
    
    [self leftTableView];
    [self rightCollectionView];
    [self xlCollectionViewWithResource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)xlCollectionViewWithResource {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"liwushuo.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *categories = dic[@"data"][@"categories"];
    for (NSDictionary *dic in categories) {
        LiwushuoModel *model = [LiwushuoModel liwushuoWithDictionary:dic];
        [self.categoryArray addObject:model];
    }
    
    [self.leftTableView reloadData];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

// MARK: - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMLeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMLeftTableCell class]) forIndexPath:indexPath];
    
    LiwushuoModel *model = self.categoryArray[indexPath.row];
    cell.typeL.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _isSelectIndex = indexPath.row;
    
    // http://stackoverflow.com/questions/22100227/scroll-uicollectionview-to-section-header-view
    // 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
    [self scrollToTopOfSection:_isSelectIndex animated:YES];
    
//    [self.rightCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_isSelectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_isSelectIndex inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// MARK: - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题
- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated {
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - self.rightCollectionView.contentInset.top);
    
    [self.rightCollectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.rightCollectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

// MARK: - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.categoryArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    LiwushuoModel *model = self.categoryArray[section];
    return model.subArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMRightCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMRightCollectionCell class]) forIndexPath:indexPath];
    LiwushuoModel *model = self.categoryArray[indexPath.section];
    GiftModel *giftModel = model.subArray[indexPath.row];
    
    cell.nameL.text = giftModel.name;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:giftModel.icon_url] placeholderImage:[UIImage imageNamed:@"Normal"]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        XMGiftReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMGiftReusableView class]) forIndexPath:indexPath];
        
        LiwushuoModel *model = self.categoryArray[indexPath.section];
        
        reusableView.titleL.text = model.name;
        
        return reusableView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.width - self.leftTableView.width, 40.0f);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    // 当前CollectionView滚动的方向向上, CollectionView是用户拖拽而产生滚动的(主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的)
    if (!_isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    // 当前CollectionView滚动的方向向下, CollectionView是用户拖拽而产生滚动的(主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的)
    if (_isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候, 处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

// MARK: - UIScrollView Delegate
// 标记一下CollectionView的滚动方向, 是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    
    if (self.rightCollectionView == scrollView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 80, self.view.height - 64.0f) style:UITableViewStylePlain];
        
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        [_leftTableView registerClass:[XMLeftTableCell class] forCellReuseIdentifier:NSStringFromClass([XMLeftTableCell class])];
        
        _leftTableView.rowHeight = 60.0f;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _leftTableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (XMCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        self.flowLayout = [[XMCollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((self.view.width - 80 - 4 - 4) / 3, (self.view.width - 80 - 4 - 4) / 3 + 20.0f);
        _flowLayout.minimumLineSpacing = 4.0f;
        _flowLayout.minimumInteritemSpacing = 4.0f;
    }
    return _flowLayout;
}

- (UICollectionView *)rightCollectionView {
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((self.view.width - 80 - 4 - 4) / 3, (self.view.width - 80 - 4 - 4) / 3 + 20.0f);
        flowLayout.minimumLineSpacing = 4.0f;
        flowLayout.minimumInteritemSpacing = 4.0f;
        
        self.rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.leftTableView.right, self.leftTableView.top, self.view.width - self.leftTableView.width, self.leftTableView.height) collectionViewLayout:self.flowLayout];
        
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
        [_rightCollectionView registerClass:[XMRightCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([XMRightCollectionCell class])];
        [_rightCollectionView registerClass:[XMGiftReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMGiftReusableView class])];
        
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_rightCollectionView];
        
    }
    return _rightCollectionView;
}

- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        self.categoryArray = [NSMutableArray new];
    }
    return _categoryArray;
}

@end
