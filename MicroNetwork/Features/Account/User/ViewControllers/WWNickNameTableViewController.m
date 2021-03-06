//
//  WWNickNameTableViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/10.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWNickNameTableViewController.h"
#import "WWUserServices.h"
#import "NSUserDefaults+Signin.h"

@interface WWNickNameTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WWNickNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNickName:(UIBarButtonItem *)sender {
    __weak __block typeof(self) weakSelf = self;
    [WWUserServices requestUploadNickName:self.textField.text resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (error == nil) {
            if (baseModel.ret == KERN_SUCCESS) {
                [[NSUserDefaults standardUserDefaults] setNickName:self.textField.text];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } 
        } else {
            
        }
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
