//
//  UIImage+extension.m
//  身份证识别
//
//  Created by Gzedu on 2017/3/18.
//  Copyright © 2017年 Gzedu. All rights reserved.
//

#import "UIImage+extension.h"

@implementation UIImage (extension)
+ (UIImage *)scaleImageWithImage:(UIImage *)image dimension:(CGFloat)dimension{
    CGSize size = CGSizeMake(dimension, dimension);
    CGFloat scaleFaclor;
    if (image.size.width > image.size.height) {
        scaleFaclor = image.size.height / image.size.width;
        size.width = dimension;
        size.height = scaleFaclor * size.width;
    }else{
        scaleFaclor = image.size.width / image.size.height;
        size.height = dimension;
        size.width = scaleFaclor * size.height;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
@end
