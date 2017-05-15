//
//  SlideView.h
//  MakerMap
//
//  Created by kevin on 16/4/13.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LeftViewBlock)(NSInteger indexRow);
@interface SlideView : UIView


@property (nonatomic,copy)LeftViewBlock leftBlock;



- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

- (void)handle:(LeftViewBlock)block;
- (void)leftViewShow:(BOOL)show;

@end
