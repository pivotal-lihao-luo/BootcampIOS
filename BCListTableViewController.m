//
//  BCListTableViewController.m
//  Bootcamp
//
//  Created by DEV FLOATER 33 on 9/6/14.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "BCListTableViewController.h"
#import "Pods/AFNetworking/AFNetworking/AFNetworking.h"
#import "BCSongData.h"
#import "BCTableViewCell.h"

@interface BCListTableViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableArray* songList;

@end

@implementation BCListTableViewController

-(void) showDialogMessage:(NSString*)message withTitle:(NSString*) title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void) handleFailureByError:(NSError*)error {
    [self.spinner startAnimating ];
}

- (NSString*) query:(NSString*)query type:(NSString*)type{
    NSString* first = @"https://partner.api.beatsmusic.com/v1/api/search?q=";
    NSString* second = @"&type=";
    NSString* third = @"&client_id=x7sjxnpy9czcvqkjebapkr5c";
    return [[[[first stringByAppendingString:query] stringByAppendingString:second] stringByAppendingString:type] stringByAppendingString:third];
}

- (NSString*) imageID:(NSString*)identifier type:(NSString*)type {
    NSString *first = @"https://partner.api.beatsmusic.com/v1/api/";
    NSString *third = @"/images/default?client_id=x7sjxnpy9czcvqkjebapkr5c&size=small";
    NSString *second = @"s/";
    return [[[[first stringByAppendingString:type] stringByAppendingString:second] stringByAppendingString:identifier] stringByAppendingString:third];
}


-(void) makeSongsWithResponse:(id)responseObject {
    [self.spinner startAnimating];
    NSDictionary *resultElements = [responseObject objectForKey:@"data"];
    NSLog(@"%lu data objects", (unsigned long)[resultElements count]);
    for (NSDictionary *element in resultElements) {
        BCSongData *curSong = [[BCSongData alloc] init];
        curSong.title = [element objectForKey:@"display"];
        curSong.detail = [element objectForKey:@"detail"];
        curSong.songID = [element objectForKey:@"id"];
        NSDictionary *related = (NSDictionary*)[element objectForKey:@"related"];
        curSong.ref_type = [related objectForKey:@"ref_type"];
        curSong.album = [related objectForKey:@"display"];
        curSong.albumID = [related objectForKey:@"id"];
        
        NSString *requestURL = [self imageID:curSong.songID type:self.typeString];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            curSong.image = responseObject;
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureByError:error];
        }];

        [self.songList addObject:curSong];
    }
    [self.tableView reloadData];
    [self.spinner stopAnimating];
    if ([self.songList count] == 0) {
        [self showDialogMessage:@"No results found." withTitle:@"Results"];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void) callSearch {
    self.spinner.hidesWhenStopped = true;
    [self.spinner startAnimating];
    self.queryString = [self.queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSLog(@"Searching for %@", self.queryString);
    NSString *requestURL = [self query:self.queryString type:self.typeString];
    self.songList = [NSMutableArray array];
    NSLog(@"Request URL = %@", requestURL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self makeSongsWithResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureByError:error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.songList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = [NSString stringWithFormat:@"Cell"];
    BCTableViewCell *cell = (BCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    
    BCSongData *songData = [self.songList objectAtIndex:[indexPath row]];
    [cell.titleText setText:songData.title];
    [cell.detailsText setText:songData.detail];
    [cell.albumLabel setText:songData.album];
    if (!songData.image) {
        cell.image.backgroundColor = [UIColor grayColor];
    } else {
        cell.image.image = songData.image;
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
