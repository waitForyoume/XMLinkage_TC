//
//  XMLinkageViewController.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMLinkageViewController.h"
#import "XMCollectionViewController.h"
#import "XMTableViewController.h"

@interface XMLinkageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *linkageTableView;
@property (nonatomic, strong) NSArray *sourceArray;

@end

@implementation XMLinkageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self linkageTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    // cell的样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.sourceArray[indexPath.row];
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f weight:5.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        XMTableViewController *tableView = [[XMTableViewController alloc] init];
        
        [self.navigationController pushViewController:tableView animated:YES];
    }
    else if (indexPath.row == 1) {
        
        XMCollectionViewController *collectionView = [[XMCollectionViewController alloc] init];
        
        [self.navigationController pushViewController:collectionView animated:YES];
    }
}

- (UITableView *)linkageTableView {
    if (!_linkageTableView) {
        self.linkageTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        
        _linkageTableView.dataSource = self;
        _linkageTableView.delegate = self;
        
        _linkageTableView.tableFooterView = [UIView new];
        [_linkageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        [self.view addSubview:_linkageTableView];
        
    }
    return _linkageTableView;
}

- (NSArray *)sourceArray {
    if (!_sourceArray) {
        self.sourceArray = @[@"TableView 联动", @"CollectionView 联动"];
    }
    return _sourceArray;
}

@end
