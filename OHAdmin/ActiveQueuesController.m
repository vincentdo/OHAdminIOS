//
//  ActiveQueuesController.m
//  OHAdmin
//
//  Created by Vincent Do on 11/28/15.
//  Copyright © 2015 Vincent Do. All rights reserved.
//

#import "ActiveQueuesController.h"
#import "QueueTableViewCell.h"
#import "ParseDataManager.h"

@interface ActiveQueuesController ()
@property (nonatomic) NSMutableArray *queues;
@property (nonatomic) ParseDataManager *dataManager;
@end

@implementation ActiveQueuesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [ParseDataManager sharedManager];
//    
//    UIImage *image = [UIImage imageNamed:@"bw-stacks.png"];
//    
//    [image drawInRect:CGRectMake(0, 0, 30, 30)];
//    
//    self.tabBarItem.image = image;
    
    [self loadData];
    // Timer Loop
    NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                             target:self
                                           selector:@selector(loadData)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadData {
    [_dataManager getOpenQueuesWithCallback:^(NSMutableArray * qs) {
        NSMutableArray * temp = [[NSMutableArray alloc] init];
        for (PFObject * obj in qs) {
            NSMutableDictionary * q = [_dataManager parseObjectToDict:obj];
            [temp addObject:q];
        }
        _queues = temp;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[QueueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell.loggedIn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary * queue = [self.queues objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = queue[@"name"];
    NSArray * staffs = queue[@"staffs"];
    NSArray * students = queue[@"students"];
    cell.staffCountLabel.text = [NSString stringWithFormat:@"%lu", staffs.count];
    cell.studentCountLabel.text = [NSString stringWithFormat:@"%lu", students.count];
    cell.loggedIn.on = [staffs containsObject:[_dataManager getCurrentUserName]];
    
    return cell;
}

- (void)switchChanged:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSString * qName = _queues[indexPath.row][@"name"];
        [_dataManager logInOrOutQueue:qName withCallback: ^(void) {
            [self loadData];
        }];
    }
}

@end
