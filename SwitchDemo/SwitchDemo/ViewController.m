//
//  ViewController.m
//  SwitchDemo
//
//  Created by Sergio Cirasa on 20/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    btn.trueStateColor = [UIColor colorWithRed:127.0/255.0 green:202.0/255.0 blue:159.0/255.0 alpha:1.0];
    btn.falseStateColor = [UIColor colorWithRed:233.0/255.0 green:109.0/255.0 blue:99.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
