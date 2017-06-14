//
//  FoodModel.h
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *price;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)foodModelWithDictionary:(NSDictionary *)dic;

@end
