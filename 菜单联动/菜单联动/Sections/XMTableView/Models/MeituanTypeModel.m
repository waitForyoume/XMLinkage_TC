//
//  MeituanTypeModel.m
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "MeituanTypeModel.h"
#import "FoodModel.h"

@implementation MeituanTypeModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)meituanTypeWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"spus"]) {
        
        NSArray *spus = value;
        for (NSDictionary *dic in spus) {
            FoodModel *model = [FoodModel foodModelWithDictionary:dic];
            
            [self.spusArray addObject:model];
        }
    }
}

- (NSMutableArray *)spusArray {
    if (!_spusArray) {
        self.spusArray = [NSMutableArray new];
    }
    return _spusArray;
}

@end
