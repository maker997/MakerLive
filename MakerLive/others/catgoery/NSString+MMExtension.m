//
//  NSString+MMExtension.m
//  Hema
//
//  Created by mengma on 16/5/8.
//  Copyright © 2016年 Hemaapp. All rights reserved.
//

#import "NSString+MMExtension.h"

@implementation NSString (MMExtension)

- (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading) attributes:dic context:nil].size;
    return contentSize.height;
}
- (CGFloat)widthWithText:(NSString *)text font:(NSInteger)font{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize contentSize = [text sizeWithAttributes:dic];
    return contentSize.width;
}

- (NSString *)changeTimeFormat:(NSString *)time
{
    //1.截取最后的秒数
    //2.把-替换成.
    NSString *tempt = [time substringToIndex:16];
    NSString *result = [tempt stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    return result;
}


@end
