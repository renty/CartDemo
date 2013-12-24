//
//  Cart.m
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import "Cart.h"

@implementation Cart
@synthesize totalPrice = _totalPrice;

- (void)setTotalPrice:(double)totalPrice
{
    
}

// 覆盖原来的get方法
- (double)totalPrice
{
    _totalPrice = 0.0f;
    [_cart enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        _totalPrice += ((CartItem *)obj).subPrice;
    }];
    return _totalPrice;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cart = [[NSMutableDictionary alloc]init];
        _goodsIDs = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (Cart *)sharedInstance
{
    // 声明一个静态变量去保存类的实例，确保它在类中的全局可用性
    static Cart *_sharedIntance = nil;
    // 声明一个静态变量dispatch_once_t，它确保初始化器代码只执行一次
    static dispatch_once_t onceToken;
    // 使用Grand Central Dispatch(GCD)执行初始化Cart变量的block，这正式但理模式的关键：一旦类被初始化，初始化器永远不会被调用。
    dispatch_once(&onceToken, ^{
        _sharedIntance = [[Cart alloc] init];
    });
    return _sharedIntance;
}
// 添加商品
- (void)addProduct:(CartItem *)item AndCount:(NSInteger) count
{
    // 判断购物车是否已经存在了待添加的商品
    if ([[_cart allKeys] containsObject:item.good.goodID]) {
        // 已经存在商品，修改购物车中商品的购买数量
        CartItem *item1 = [_cart objectForKey:item.good.goodID];
        // 将商品对象的subQuantity属性进行更新
        _goodsSize += count;
        item1.subQuentity += count;
        
    } else {
        // 不存在该商品，向购物车添加该商品
        [_cart setObject:item forKey:item.good.goodID];
        _goodsSize += count;
        item.subQuentity = count;
        [_goodsIDs addObject:item.good.goodID];
    }
}
// 删除商品
- (void)cutByPid:(NSString *)pid type:(NSString *)type
{
    CartItem *item = [_cart objectForKey:pid];
    // all：一次性删除某一类商品
    if ([type isEqualToString:@"all"]) {
        _goodsSize -= item.subQuentity;
        [_cart removeObjectForKey:pid];
        [_goodsIDs removeObject:pid];
    }
    // single：逐一删除每个商品
    else if([type isEqualToString:@"single"]) {
        // 数量为1，删除商品
        if (item.subQuentity == 1) {
            _goodsSize -= 1;
            [_cart removeObjectForKey:pid];
            [_goodsIDs removeObject:pid];
        }
        // 将商品的subQuantity属性进行更新(-1)
        else {
            _goodsSize -= 1;
            item.subQuentity -= 1;
        }
    }
}
// 商品数量加1
- (void)addByPid:(NSString *)pid
{
    CartItem *item = [_cart objectForKey:pid];
    _goodsSize += 1;
    item.subQuentity += 1;
}
// 清空购物车
- (void)clear
{
    _goodsSize = 0;
    _totalPrice = 0.f;
    [_cart removeAllObjects];
    [_goodsIDs removeAllObjects];
}

@end
