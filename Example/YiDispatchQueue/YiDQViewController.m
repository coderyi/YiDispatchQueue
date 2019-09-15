//
//  YiDQViewController.m
//  YiDispatchQueue
//
//  Created by coderyi on 09/15/2019.
//  Copyright (c) 2019 coderyi. All rights reserved.
//

#import "YiDQViewController.h"
#import "YiDispatchQueue.h"
@interface YiDQViewController ()
@property (nonatomic, strong) YiDispatchQueue *dispatchQueue;
@end

@implementation YiDQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _dispatchQueue = [[YiDispatchQueue alloc] init];
    [_dispatchQueue dispatch:^{
        NSLog(@"hello, this is test queue");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
