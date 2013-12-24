//
//  CartItem.m
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import "CartItem.h"

@implementation CartItem
@synthesize subPrice = _subPrice;

- (void)setSubPrice:(double)subPrice
{
    _subPrice = subPrice;
}

- (double)subPrice
{
    return (_subPriceUnit * _subQuentity);
}

@end
