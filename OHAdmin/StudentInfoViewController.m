//
//  StudentInfoViewController.m
//  OHAdmin
//
//  Created by Vincent Do on 11/30/15.
//  Copyright © 2015 Vincent Do. All rights reserved.
//

#import "StudentInfoViewController.h"
#import "ParseDataManager.h"

@interface StudentInfoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *pennkeyLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic) ParseDataManager * dataManager;

@end

@implementation StudentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [ParseDataManager sharedManager];
    _nameLabel.text = [_dataManager currentStudent][@"name"];
    _pennkeyLabel.text = [_dataManager currentStudent][@"pennkey"];
    _questionLabel.text = [_dataManager currentStudent][@"question"];
    _commentLabel.text = [_dataManager currentStudent][@"comment"];
    
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    _questionLabel.numberOfLines = 0;
    [_questionLabel sizeToFit];
    _commentLabel.numberOfLines = 0;
    [_commentLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickResolve:(id)sender {
    [_dataManager resolveStudentWithStatus:@"RESOLVED" andCallback:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (IBAction)onClickEscalate:(id)sender {
    [_dataManager resolveStudentWithStatus:@"ESCALATED" andCallback:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (IBAction)onClickNoShow:(id)sender {
    [_dataManager resolveStudentWithStatus:@"NO-SHOW" andCallback:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (IBAction)onClickOutOfTime:(id)sender {
    [_dataManager resolveStudentWithStatus:@"OUT-OF-TIME" andCallback:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
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
