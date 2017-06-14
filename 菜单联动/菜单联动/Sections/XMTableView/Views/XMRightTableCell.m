//
//  XMRightTableCell.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMRightTableCell.h"
#import "UIView+XMAdd.h"

@implementation XMRightTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.priceL];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
        
        _imgView.left = 15;
        _imgView.top = 15;
        _imgView.width = 50.0f;
        _imgView.height = 50.0f;
        
    }
    return _imgView;
}

- (UILabel *)nameL {
    if (!_nameL) {
        self.nameL = [[UILabel alloc] init];
        
        _nameL.left = 80.0f;
        _nameL.top = 10.0f;
        _nameL.width = 200.0f;
        _nameL.height = 30.0f;
        
        _nameL.font = [UIFont systemFontOfSize:14.0f];
        
    }
    return _nameL;
}

- (UILabel *)priceL {
    if (!_priceL) {
        self.priceL = [[UILabel alloc] init];
        
        _priceL.top = 45.0f;
        _priceL.left = 80.0f;
        _priceL.width = 200.0f;
        _priceL.height = 30.0f;
        
        _priceL.font = [UIFont systemFontOfSize:14.0f];
        _priceL.textColor = [UIColor redColor];
    }
    return _priceL;
}

@end
