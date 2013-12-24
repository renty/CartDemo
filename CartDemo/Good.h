//
//  Good.h
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject

@property (nonatomic, strong)NSString *goodID;
@property (nonatomic, strong)NSString *goodName;
@property (nonatomic, strong)NSString *goodImageName;
@property double goodPrice;

- (id)initGoodWithgoodID:(NSString *)goodID goodName:(NSString *)goodName goodImageName:(NSString *)goodImageName goodPrice:(double)goodPrice;

@end
