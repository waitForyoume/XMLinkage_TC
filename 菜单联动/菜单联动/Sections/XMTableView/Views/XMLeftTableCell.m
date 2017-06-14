//
//  XMLeftTableCell.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMLeftTableCell.h"
#import "UIView+XMAdd.h"

@interface XMLeftTableCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation XMLeftTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.typeL];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.highlighted = selected;
    self.typeL.highlighted = selected;
    self.lineView.hidden = !selected;
    
}

- (UILabel *)typeL {
    if (!_typeL) {
        self.typeL = [[UILabel alloc] init];
        
        _typeL.left = 10.0f;
        _typeL.top = 0;
        _typeL.width = 70.0f;
        _typeL.height = 60.0f;
        
        _typeL.numberOfLines = 0;
        _typeL.textColor = [UIColor colorWithRed:130.0f / 255.0f green:130.0f / 255.0f blue:130.0f / 255.0f alpha:1];
        _typeL.highlightedTextColor = [UIColor purpleColor];
        _typeL.font = [UIFont systemFontOfSize:16.0f];
        
    }
    return _typeL;
}

- (UIView *)lineView {
    if (!_lineView) {
        self.lineView = [[UIView alloc] init];
        
        _lineView.left = 0;
        _lineView.top = 10.0f;
        _lineView.height = 40.0f;
        _lineView.width = 4.5f;
        
        _lineView.backgroundColor = [UIColor purpleColor];
    }
    return _lineView;
}

@end
