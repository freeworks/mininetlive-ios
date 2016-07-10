//
//  WWGenderTableViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/10.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWGenderTableViewController.h"
#import "NSUserDefaults+Signin.h"
#import "WWUserServices.h"

typedef enum : NSUInteger {
    MyGenderWoman = 0,
    MyGenderMan,
} MyGender;

@interface WWGenderTableViewController ()

@property (strong, nonatomic) UITableViewCell *currentCell;
@property (strong, nonatomic) NSArray *array;
@property (nonatomic) NSInteger gender;
@end

@implementation WWGenderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"女", @"男"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveGender:(UIBarButtonItem *)sender {
    [WWUserServices requestUploadGender:self.gender resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.array[indexPath.row];
    
    if (indexPath.row == 0) {
        if ([[NSUserDefaults standardUserDefaults].gender isEqual:@(MyGenderWoman)]) {
            [self setCell:cell];
        }
    } else {
        if ([[NSUserDefaults standardUserDefaults].gender isEqual:@1]) {
            [self setCell:cell];
        }
    }
    
    return cell;
}

- (void)setCell:(UITableViewCell *)cell {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentCell = cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    if (self.currentCell != cell) {
        self.currentCell.accessoryType = UITableViewCellAccessoryNone;
        self.currentCell = cell;
    }
    self.gender = indexPath.row;
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
