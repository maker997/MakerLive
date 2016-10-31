//
//  NSString+MMExtension.h
//  Hema
//
//  Created by mengma on 16/5/8.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MMExtension)

- (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
- (CGFloat)widthWithText:(NSString *)text font:(NSInteger)font;
- (NSString *)changeTimeFormat:(NSString *)time;
@end
