//
//  LiwushuoModel.h
//  菜单联动
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiwushuoModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, strong) NSMutableArray *subArray;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)liwushuoWithDictionary:(NSDictionary *)dic;

@end
