//
//  LiwushuoModel.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "LiwushuoModel.h"
#import "GiftModel.h"

@implementation LiwushuoModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)liwushuoWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"subcategories"]) {
        NSArray *subcategories = value;
        for (NSDictionary *dic in subcategories) {
            GiftModel *model = [GiftModel giftWithDictionary:dic];
            [self.subArray addObject:model];
        }
    }
}

- (NSMutableArray *)subArray {
    if (!_subArray) {
        self.subArray = [NSMutableArray new];
    }
    return _subArray;
}

@end
