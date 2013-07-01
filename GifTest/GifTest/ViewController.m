//
//  ViewController.m
//  GifTest
//
//  Created by Daniate on 13-6-28.
//  Copyright (c) 2013年 ChinaEBI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", arc4random() % 11] ofType:@"gif"];
	GIFImageView *gif = [[GIFImageView alloc] initWithGIFFile:filePath];
	gif.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	gif.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:gif];
	[gif release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
