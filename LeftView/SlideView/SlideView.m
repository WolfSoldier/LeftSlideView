//
//  SlideView.m
//  MakerMap
//
//  Created by kevin on 16/4/13.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "SlideView.h"
#import "UIView+Ext.h"



@interface SlideView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *superView;
@end
@implementation SlideView
{
    UIView *viewBack;
    UIPanGestureRecognizer *viewPan;
    BOOL canShowLeft;
    BOOL canHideLeft;
    CGFloat panOriginX;
    
}

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super initWithFrame:frame]) {
        
        _superView = superView;
        [self createUI];
        [self superHandle];
    }
    
    return self;
}
- (void)superHandle
{
    viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [viewBack addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftViewShow:)]];
    
    viewPan = [[UIPanGestureRecognizer alloc]init];
    viewPan.delegate = self;
    [viewPan addTarget:self action:@selector(viewPan:)];
    [_superView addGestureRecognizer:viewPan];
}

- (void)createUI
{
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.sizeWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}


- (void)viewPan:(UIPanGestureRecognizer *)pan
{
    CGPoint locate = [pan locationInView:_superView];
    
    //    NSLog(@"locate%f",locate.x);
    if (pan.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"Began%f",locate.x);
        BOOL isLeftShow = self.originX != -self.sizeWidth-5;
        
        panOriginX = locate.x;
        if (!isLeftShow) {
            if (panOriginX<50) {
                
                [self.superview addSubview:viewBack];
                [self.superview addSubview:self];
                canShowLeft = YES;
            }
            else
            {
                canShowLeft = NO;
            }
            canHideLeft = NO;
        }
        else
        {
            canHideLeft = YES;
            canShowLeft = NO;
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        //        NSLog(@"Ended%f",locate.x);
        if (canShowLeft) {
            [self handleShowPoint:locate.x target:120];
        }
        else if (canHideLeft) {
            [self handleShowPoint:locate.x target:250];
        }
    }
    
    if ((canShowLeft)&&pan.state != UIGestureRecognizerStateEnded&&pan.state != UIGestureRecognizerStateBegan) {
        CGFloat offsetX = (locate.x - panOriginX)-self.sizeWidth;
        
        if (offsetX<0) {
            CGFloat scale = (self.originX + self.sizeWidth)/self.sizeWidth;
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4*scale];
            self. originX = offsetX;
        }
        
    }
    else if (canHideLeft&&pan.state != UIGestureRecognizerStateEnded&&pan.state != UIGestureRecognizerStateBegan) {
        CGFloat offsetX = -(panOriginX -locate.x);
        
        if (offsetX<0) {
            self. originX = offsetX;
//            
            CGFloat scale = (self.originX + self.sizeWidth)/self.sizeWidth;
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4*scale];
        }
        else
        {
            canHideLeft = NO;
        }
    }
}
- (void)handleShowPoint:(CGFloat)pointX target:(CGFloat)targetX
{
    if (pointX>targetX) {
//        NSLog(@"show");
        [self leftViewShow:YES];
        canShowLeft = NO;
        canHideLeft = YES;
    }
    else
    {
        [self leftViewShow:NO];
//        NSLog(@"hide");
        canHideLeft = NO;
    }
}

- (void)leftViewShow:(BOOL)show
{
    if (show) {
        
        
        if (viewBack.superview == nil) {
            [self.superview addSubview:viewBack];
            [self.superview addSubview:self];
        }
        [UIView animateWithDuration:0.35 delay:0.f usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            self.originX = 0;
        }completion:nil];
    }
    else
    {
        
        [UIView animateWithDuration:0.35 delay:0.f usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.originX = -self.sizeWidth-5;
            viewBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        }completion:^(BOOL finished) {
            [viewBack removeFromSuperview];
        }];
    }
}
- (void)handle:(LeftViewBlock)block
{
    if (block) {
        _leftBlock = block;
    }
}
#pragma mark - UITableViewDelegate & UITableViewDataSource


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self leftViewShow:NO];
    if (_leftBlock) {
        _leftBlock(IndexRow);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text = @"123";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

@end
