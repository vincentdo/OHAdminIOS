//
//  HelpStudentViewController.m
//  OHAdmin
//
//  Created by Vincent Do on 11/30/15.
//  Copyright © 2015 Vincent Do. All rights reserved.
//

#import "HelpStudentViewController.h"
#import "ParseDataManager.h"
#import "EscalatedStudentTableViewCell.h"

@interface HelpStudentViewController ()
@property (nonatomic) ParseDataManager *dataManager;
@property (strong, nonatomic) IBOutlet UIButton *getStudent;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

@implementation HelpStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [ParseDataManager sharedManager];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
    
    [self loadData];
    // Timer Loop
    NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                             target:self
                                           selector:@selector(loadData)
                                           userInfo:nil
                                            repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickGetStudent:(id)sender {
    [_dataManager getNextStudentWithCallback:^(NSMutableArray * students) {
        if (students.count == 0) {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"No Student"
                                                                                       message: @"There are no students to help in the queues you are logged in."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here, eg dismiss the alertwindow
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            //Step 3: Add the UIAlertAction ok that we just created to our AlertController
            [myAlertController addAction: ok];
            
            //Step 4: Present the alert to the user
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
        else {
            [self performSegueWithIdentifier: @"segueToStudentInfoView" sender:self];
        }
    }];
}

- (void) loadData {
    [_dataManager getEscalatedStudentsWithCallback:^{
        [_tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataManager escalatedStudents].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EscalatedStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[EscalatedStudentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell.helpButton addTarget:self action:@selector(helpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * students = [_dataManager escalatedStudents];
    PFObject * st = students[indexPath.row];
    cell.nameLabel.text = st[@"name"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:st.updatedAt];
    cell.timeLabel.text = dateString;
    
    return cell;
}

- (void) helpButtonPressed:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        UIViewController * view = self;
        NSArray * students = [_dataManager escalatedStudents];
        [_dataManager setEscalatedStudentWith:students[indexPath.row][@"pennkey"] andCallback:^{
            [view performSegueWithIdentifier: @"segueToStudentInfoView" sender:view];
        }];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
