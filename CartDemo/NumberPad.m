//
//  NumberPad.m
//  ZXingTest
//
//  Created by CY-003 on 13-11-19.
//  Copyright (c) 2013年 CY-003. All rights reserved.
//

#import "NumberPad.h"

@interface NumberPad ()

- (IBAction)buttonPressed:(UIButton *)sender;

@end

@implementation NumberPad

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.inputNumber = @"";
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"C"])
    {
        self.inputNumber = @"";
        [self stringChanged];
        return;
    }
    
    if ([self.inputNumber isEqualToString:@""] && [sender.currentTitle isEqualToString:@"0"] )
    {
        return;
    }
    else if ([self.inputNumber isEqualToString:@""] && [sender.currentTitle isEqualToString:@"."])
    {
        self.inputNumber = @"0.";
        [self stringChanged];
        return;
    }
    else if (([self.inputNumber rangeOfString:@"."].length > 0) && [sender.currentTitle isEqualToString:@"."])
    {
        return;
    }
    
    self.inputNumber = [self.inputNumber stringByAppendingString:sender.currentTitle];
    
    if ([self.inputNumber doubleValue] > 100.f) {
        self.inputNumber = @"100";
        [self stringChanged];
        self.inputNumber = @"";
        return;
    }
    
    [self stringChanged];
}

-(void) stringChanged
{
    [self.delegate stringChanged:self.inputNumber];
}



@end
