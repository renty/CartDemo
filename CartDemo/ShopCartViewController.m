//
//  CartViewController.m
//  CartDemo
//
//  Created by SUNMAC on 13-11-19.
//  Copyright (c) 2013年 lvpw. All rights reserved.
//
#define kDuihaoView 1
#define kGoodImageView 2
#define kGoodName 3
#define kBigKuang 4
#define kGoodPrice 5
#define kGoodCount 6

#import "ShopCartViewController.h"
#import "Cart.h"
#import "CartItem.h"
#import "Good.h"
#import "NumberPad.h"

@interface ShopCartViewController () <UITableViewDataSource, UITableViewDelegate, NumberPadDelegate, UITextFieldDelegate>

@end

@implementation ShopCartViewController

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 判断是否为数字、回退和'.'
    if (!([string isEqualToString:@"1"] || [string isEqualToString:@"2"] || [string isEqualToString:@"4"] || [string isEqualToString:@"3"] || [string isEqualToString:@"5"] || [string isEqualToString:@"6"] || [string isEqualToString:@"7"] || [string isEqualToString:@"8"] || [string isEqualToString:@"9"] || [string isEqualToString:@"0"] || [string isEqualToString:@"."] || [string isEqualToString:@""])) {
        return NO;
    }
    NSString *end = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *array = [end componentsSeparatedByString:@"."];
    if ([array count] < 2) {
        if (((NSString *)[array objectAtIndex:0]).length <= 5) return YES;
        else return NO;
    } else if([array count] == 2){
        if (((NSString *)[array objectAtIndex:0]).length <= 5 && ((NSString *)[array objectAtIndex:1]).length <= 2) return YES;
        else return NO;
    } else return NO;
}

#pragma mark - NumberPadDelegate

- (void)stringChanged:(NSString *)string
{
    _discount.text = string;
    [self updatePrice];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Cart sharedInstance].goodsIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CartViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CartViewCell" owner:self options:nil];
        if ([nib count] > 0) {
            cell = [nib objectAtIndex:0];
        }
    }
    CartItem *item = [self cartItemAtIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:kGoodName]).text = item.good.goodName;
    ((UITextField *)[cell viewWithTag:kGoodPrice]).text = [NSString stringWithFormat:@"%.2f",item.subPriceUnit];
    ((UILabel *)[cell viewWithTag:kGoodCount]).text = [NSString stringWithFormat:@"%d", item.subQuentity];
    ((UIImageView *)[cell viewWithTag:kDuihaoView]).hidden = item.duihaoStatus;
    return cell;
}

#pragma mark - Handle Action

- (IBAction)deleteCartItem:(id)sender event:(id)event
{
    UITableViewCell *cell = [_cartTableView cellForRowAtIndexPath:[_cartTableView indexPathForRowAtPoint:[[[event allTouches]anyObject] locationInView:_cartTableView]]];
    int row = [_cartTableView indexPathForCell:cell].row;
    NSString *pid = [[Cart sharedInstance].goodsIDs objectAtIndex:row];
    [[Cart sharedInstance] cutByPid:pid type:@"all"];
    [_cartTableView reloadData];
    [self updatePrice];
}

- (IBAction)changePrice:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    CartItem *item = [self cartItemAtIndexPath:[_cartTableView indexPathForCell:cell]];
    item.subPriceUnit = [[NSString stringWithFormat:@"%.2f", [((UITextField *)sender).text doubleValue]] doubleValue];
    ((UITextField *)sender).text = [NSString stringWithFormat:@"%.2f", item.subPriceUnit];
    [self updatePrice];
}

- (IBAction)cutQuantity:(id)sender event:(id)event
{
    UITableViewCell *cell = [_cartTableView cellForRowAtIndexPath:[_cartTableView indexPathForRowAtPoint:[[[event allTouches]anyObject] locationInView:_cartTableView]]];
    int row = [_cartTableView indexPathForCell:cell].row;
    NSString *pid = [[Cart sharedInstance].goodsIDs objectAtIndex:row];
    [[Cart sharedInstance] cutByPid:pid type:@"single"];
    [_cartTableView reloadData];
    [self updatePrice];
}

- (IBAction)addQuantity:(id)sender event:(id)event
{
    UITableViewCell *cell = [_cartTableView cellForRowAtIndexPath:[_cartTableView indexPathForRowAtPoint:[[[event allTouches]anyObject] locationInView:_cartTableView]]];
    int row = [_cartTableView indexPathForCell:cell].row;
    NSString *pid = [[Cart sharedInstance].goodsIDs objectAtIndex:row];
    [[Cart sharedInstance] addByPid:pid];
    [_cartTableView reloadData];
    [self updatePrice];
}

- (IBAction)ShowOrHideDuihao:(id)sender event:(id)event
{
    UITableViewCell *cell = [_cartTableView cellForRowAtIndexPath:[_cartTableView indexPathForRowAtPoint:[[[event allTouches]anyObject] locationInView:_cartTableView]]];
    [self cartItemAtIndexPath:[_cartTableView indexPathForCell:cell]].duihaoStatus =  [self HandleDuihao:cell];
}

- (IBAction)ChooseOrCancleAllDuihao:(id)sender
{
    BOOL status = [self HandleDuihao:[sender superview]];
    UITableViewCell *cell = nil;
    for (int i = 0; i < [_cartTableView numberOfRowsInSection:0]; i++) {
        cell = [_cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell viewWithTag:kDuihaoView].hidden = status;
        [self cartItemAtIndexPath:[_cartTableView indexPathForCell:cell]].duihaoStatus = status;
    }
}

- (void)deleteChooseGoods:(UIGestureRecognizer *)recognizer
{
    NSMutableArray *goosIDNeedRemove = [NSMutableArray array];
    for (int i = 0; i < [[Cart sharedInstance].goodsIDs count]; i++) {
        NSString *goodId = [[Cart sharedInstance].goodsIDs objectAtIndex:i];
        CartItem *item = [[Cart sharedInstance].cart objectForKey:goodId];
        if (!item.duihaoStatus) {
            [goosIDNeedRemove addObject:goodId];
        }
    }
    [[Cart sharedInstance].cart removeObjectsForKeys:goosIDNeedRemove];
    [[Cart sharedInstance].goodsIDs removeObjectsInArray:goosIDNeedRemove];
    [_cartTableView reloadData];
    _duihao.hidden = YES;
    [self updatePrice];
}

#pragma mark - Utility

- (CartItem *)cartItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *goodId = [[Cart sharedInstance].goodsIDs objectAtIndex:indexPath.row];
    CartItem *item = [[Cart sharedInstance].cart objectForKey:goodId];
    return item;
}

- (BOOL)HandleDuihao:(UIView *)view
{
    UIImageView *duihao = (UIImageView *)[view viewWithTag:kDuihaoView];
    duihao.hidden = !duihao.hidden;
    return duihao.hidden;
}

- (void)updatePrice
{
    double totalPrice = [Cart sharedInstance].totalPrice;
    double discountPrice = totalPrice*(100-[_discount.text doubleValue])/100;
    double endPrice = totalPrice - discountPrice;
    _totalPrice.text = [NSString stringWithFormat:@"￥%.2f", totalPrice];
    _discountPrice.text = [NSString stringWithFormat:@"￥%.2f", discountPrice];
    _endPrice.text = [NSString stringWithFormat:@"￥%.2f", endPrice];
}

#pragma mark - Init

- (void)initCart
{
    Good *good1 = [[Good alloc]initGoodWithgoodID:@"1001" goodName:@"1001" goodImageName:nil goodPrice:50.f];
    Good *good2 = [[Good alloc]initGoodWithgoodID:@"1002" goodName:@"1002" goodImageName:nil goodPrice:100.f];
    Good *good3 = [[Good alloc]initGoodWithgoodID:@"1003" goodName:@"1003" goodImageName:nil goodPrice:0.f];
    
    CartItem *item1 = [[CartItem alloc]init];
    item1.good = good1;
    item1.subQuentity = 2;
    item1.subPriceUnit = good1.goodPrice;
    item1.duihaoStatus = YES;
    CartItem *item2 = [[CartItem alloc]init];
    item2.good = good2;
    item2.subQuentity = 1;
    item2.subPriceUnit = good2.goodPrice;
    item2.duihaoStatus = YES;
    CartItem *item3 = [[CartItem alloc]init];
    item3.good = good3;
    item3.subQuentity = 10;
    item3.subPriceUnit = good3.goodPrice;
    item3.duihaoStatus = YES;
    
    [[Cart sharedInstance]addProduct:item1 AndCount:item1.subQuentity];
    [[Cart sharedInstance]addProduct:item2 AndCount:item2.subQuentity];
    [[Cart sharedInstance]addProduct:item3 AndCount:item3.subQuentity];
}

- (void)initNumberPadView
{
    NumberPad *numberPad = [[NumberPad alloc]initWithNibName:@"NumberPad" bundle:nil];
    numberPad.delegate = self;
    numberPad.view.frame = (CGRect){.origin=CGPointMake(0, 15), .size=numberPad.view.frame.size};
    [_numberPadView addSubview:numberPad.view];
    [self addChildViewController:numberPad];
}

- (void)initDeleteChooseGoods
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteChooseGoods:)];
    [_deleteChooseGoods addGestureRecognizer:tap];
}

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initCart];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNumberPadView];
    
    [self updatePrice];
    
    [self initDeleteChooseGoods];
    // branch1 test
    
    // branch2 text
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
