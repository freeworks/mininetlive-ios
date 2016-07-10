//
//  WWUniversalListTableViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/9.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWUniversalListTableViewController.h"
#import "WWUserServices.h"
#import "WWAppointmentTableViewCell.h"
#import "WWPlayListTableViewCell.h"


typedef enum : NSUInteger {
    MyListTypeAppointment = 1,
    MyListTypePay,
    MyListTypePlay,
} MyListType;

@interface WWUniversalListTableViewController ()

@property (strong, nonatomic) NSArray *list;
@end

@implementation WWUniversalListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [self requestListType:self.listType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestListType:(NSInteger)listType {
    __weak __block typeof(self) weakSelf = self;
    [WWUserServices requestListType:listType resultBlock:^(NSArray *list, NSError *error) {
        weakSelf.list = list;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == MyListTypeAppointment) {
        WWAppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Appointment Cell" forIndexPath:indexPath];
        [cell setUniversalListCell:self.list[indexPath.row]];
        return cell;
    } else {
        WWPlayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Play Cell" forIndexPath:indexPath];
        [cell setPlayList:self.list[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.listType == MyListTypePay) {
//        return 152;
//    } else {
//        return 84;
//    }
//}


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
