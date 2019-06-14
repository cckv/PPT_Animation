//
//  ViewController.m
//  Test_Animation
//
//  Created by bairuitech on 2019/6/14.
//  Copyright © 2019年 CCKV. All rights reserved.
//

#import "ViewController.h"
#import "KVPieView.h"

@interface ViewController ()<KVPieViewDelegate>
@property (nonatomic, strong) KVPieView *mypie;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mypie = [[KVPieView alloc] initWithFrame:CGRectMake(110, 100, 100, 100) textItems:@[@"第一页",@"第二页",@"第三页"] timeItems:@[@1,@5,@3] colorItems:@[]];
    [self.view addSubview:_mypie];
    _mypie.delegate = self;
    
}

- (IBAction)start:(id)sender {
    [_mypie startPlay];
}
- (IBAction)resue:(id)sender {
    [_mypie resume];
}
- (IBAction)pause:(id)sender {
    [_mypie pause];
}

@end
