//
//  CartViewController.h
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//

#import <UIKit/UIKit.h>
// branch1 test
@interface ShopCartViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *duihao;
@property (strong, nonatomic) IBOutlet UIView *deleteChooseGoods;
@property (strong, nonatomic) IBOutlet UILabel *discount;
@property (strong, nonatomic) IBOutlet UIView *numberPadView;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong, nonatomic) IBOutlet UILabel *discountPrice;
@property (strong, nonatomic) IBOutlet UILabel *endPrice;

@property (strong, nonatomic) IBOutlet UITableView *cartTableView;
- (IBAction)ShowOrHideDuihao:(id)sender event:(id)event;
- (IBAction)ChooseOrCancleAllDuihao:(id)sender;
- (IBAction)cutQuantity:(id)sender event:(id)event;
- (IBAction)addQuantity:(id)sender event:(id)event;
- (IBAction)deleteCartItem:(id)sender event:(id)event;
- (IBAction)changePrice:(id)sender;
@end
