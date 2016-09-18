//
//  ECViewController.m
//  ECSegment
//
//  Created by Jame on 09/18/2016.
//  Copyright (c) 2016 Jame. All rights reserved.
//

#import "ECViewController.h"
#import "ECSegment.h"

@interface ECViewController () <ECSegmentDelegate>

@property (nonatomic, strong) ECSegment *segment;

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.segment = [[ECSegment alloc] ec_initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40) style:ECSegmentLineStyle];
    self.segment.ec_delegate = self;
    self.segment.ec_itemDefaultColor = [UIColor blackColor];
    self.segment.ec_itemSelectedColor = [UIColor orangeColor];
    self.segment.ec_itemStyleSelectedColor = [UIColor orangeColor];
    self.segment.ec_backgroundColor = [UIColor clearColor];
    [self.segment ec_setItems:@[@"周一",@"周二",@"周三"]];
    [self.view addSubview:self.segment];
    
}


- (void)ec_selectSegmentWithIndex:(NSInteger)selectIndex
{
    NSArray *item = @[@"周一",@"周二",@"周三"];
    NSLog(@"%@",item[selectIndex]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
