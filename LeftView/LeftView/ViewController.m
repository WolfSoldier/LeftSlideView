//
//  ViewController.m
//  LeftView
//
//  Created by kevin on 16/4/18.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "ViewController.h"
#import "SlideView.h"
@interface ViewController ()

@property (strong,nonatomic)SlideView *leftView;

@end

@implementation ViewController
#define leftWidth (280)
- (void)leftViewSet
{
    _leftView = [[SlideView alloc]initWithFrame:CGRectMake(-leftWidth-5, 0, leftWidth, ScreenHeight) superView:AppWindow];
    
    [AppWindow addSubview:_leftView];
    [_leftView handle:^(NSInteger indexRow) {
        NSLog(@"%d",(int)indexRow);
        [_leftView leftViewShow:NO];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(clickBtn:)];
    self.navigationItem.leftBarButtonItem = left;

    
    [self leftViewSet];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickBtn:(id)sender {
    [_leftView leftViewShow:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
