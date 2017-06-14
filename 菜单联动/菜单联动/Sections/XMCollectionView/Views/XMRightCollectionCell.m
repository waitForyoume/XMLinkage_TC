//
//  XMRightCollectionCell.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMRightCollectionCell.h"
#import "UIView+XMAdd.h"

@implementation XMRightCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.nameL];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
        
        _imgView.left = 7.0f;
        _imgView.width = self.width - 14.0f;
        _imgView.top = 7.0f;
        _imgView.height = _imgView.width;
    }
    return _imgView;
}

- (UILabel *)nameL {
    if (!_nameL) {
        self.nameL = [[UILabel alloc] init];
        
        _nameL.top = self.height - 35.0f;
        _nameL.left = 0;
        _nameL.width = self.width;
        _nameL.height = 30.0f;
        
        _nameL.textAlignment = 1;
        _nameL.font = [UIFont systemFontOfSize:14.0f];
        _nameL.numberOfLines = 0;
    }
    return _nameL;
}

@end
