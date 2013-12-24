//
//  Good.m
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import "Good.h"

@implementation Good

- (id)initGoodWithgoodID:(NSString *)goodID goodName:(NSString *)goodName goodImageName:(NSString *)goodImageName goodPrice:(double)goodPrice
{
    self = [super init];
    if (self) {
        _goodID = goodID;
        _goodName = goodName;
        _goodImageName = goodImageName;
        _goodPrice = goodPrice;
    }
    return self;
}

@end
