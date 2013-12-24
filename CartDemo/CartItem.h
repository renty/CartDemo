//
//  CartItem.h
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Good.h"

@interface CartItem : NSObject

@property NSInteger subQuentity;
@property double subPrice;
@property double subPriceUnit;
@property (nonatomic, strong)Good *good;
@property BOOL duihaoStatus;

@end
