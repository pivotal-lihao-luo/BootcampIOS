//
//  BCSearchController.m
//  Bootcamp
//
//  Created by DEV FLOATER 33 on 9/7/14.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "BCSearchController.h"
#import "BCListTableViewController.h"

@interface BCSearchController ()
@property (weak, nonatomic) IBOutlet UITextField *queryTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSelector;
@property (strong, nonatomic) NSString *curSelected;

@end

@implementation BCSearchController

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *test = segue.identifier;
    if ([test isEqualToString:@"searchSegue"]) {
        BCListTableViewController * vc = [segue destinationViewController];
        vc.queryString = [self.queryTextField text];
        vc.typeString = self.curSelected;
    }
}

-(IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)changeType:(id)sender {
    if ([self.typeSelector selectedSegmentIndex] == 0) {
        self.curSelected = @"track";
    } else if ([self.typeSelector selectedSegmentIndex] == 1) {
        self.curSelected = @"artist";
    } else {
        self.curSelected = @"album";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.curSelected = @"track";
    [self.typeSelector addTarget:self
                                action:@selector(changeType:)
                      forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
