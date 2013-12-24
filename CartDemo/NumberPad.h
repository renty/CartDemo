//
//  NumberPad.h
//  ZXingTest
//
//  Created by CY-003 on 13-11-19.
//  Copyright (c) 2013年 CY-003. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberPadDelegate <NSObject>

@required
- (void) stringChanged:(NSString *)string;

@end

@interface NumberPad : UIViewController

@property (nonatomic,copy) NSString *inputNumber;

@property (nonatomic,strong) id<NumberPadDelegate> delegate;

@end
