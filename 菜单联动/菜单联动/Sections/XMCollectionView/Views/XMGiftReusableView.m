//
//  XMGiftReusableView.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMGiftReusableView.h"

@implementation XMGiftReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _titleL.textAlignment = 1;
        _titleL.font = [UIFont systemFontOfSize:16.0f weight:5.0f];
        
        [self addSubview:_titleL];
        
    }
    return self;
}

@end
