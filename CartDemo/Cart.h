//
//  Cart.h
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartItem.h"

@interface Cart : NSObject

@property double totalPrice;
@property (nonatomic, strong) NSString *type;
@property double discount;
@property NSInteger goodsSize;
@property (nonatomic, strong) NSMutableDictionary *cart;
@property (nonatomic, strong) NSMutableArray *goodsIDs;

+ (Cart *)sharedInstance;
- (void)addProduct:(CartItem *)item AndCount:(NSInteger) count;
- (void)cutByPid:(NSString *)pid type:(NSString *)type;
- (void)addByPid:(NSString *)pid;
- (void)clear;

@end
