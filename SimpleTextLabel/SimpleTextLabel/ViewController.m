//
//  ViewController.m
//  SimpleTextLabel
//
//  Created by yanmingjun on 16/3/23.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CoreTextView *coreTextView = [[CoreTextView alloc] initWithFrame:self.view.bounds];
    coreTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:coreTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
