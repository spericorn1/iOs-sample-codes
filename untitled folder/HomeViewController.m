
/* This page is designed with multiple cells in which contents are loaded dynamically with AFNetworking. This code can be used for latest shopping cart with dynamic item. This is a home page. */

/*The API s are handled using a manual class called AFServiceManager*/



#import "HomeViewController.h"
#import "AFServiceManager.h"
#import "ARExpandableSideMenu.h"
#import "SVProgressHUD.h"
#import "NewsTableViewCell.h"
#import "TopAnalysisTableViewCell.h"
#import "GenericFunctions.h"
#import "FAMovementTableViewCell.h"
#import "NewsAndViewsTableViewCell.h"
#import "HeadlineNewsAnalysisTableViewCell.h"
#import "FantasyColumnWritersTableViewCell.h"
#import "FantasyLatestColumnsTableViewCell.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *arrayHomeAllData;
    NSArray *arrayDiehardsNews ,*arrayTopAnalysis, *arrayFAMovements, *arrayNewsAndViews, *arrayHeadlineNewsAnalysis, *arrayFantasyColumnWriters, *arrayFantasyLatestColumns;
}

@end
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    arrayHomeAllData = [[NSMutableArray alloc] init];
    [self fetchHomeNewsAndDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method is used to assign values to the userdefined variables after calling the API.
-(void)fetchHomeNewsAndDetails{
    NSMutableDictionary * dataDict;
    dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:@"getHomeNews" forKey:@"method"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Loading"];
    [[AFServiceManager mySharedManager] getDataFromService:@"cheetsheetapi.cfc?" withParameters:dataDict withCompletionBlock:^(BOOL success, id result, NSError *error) {
        if (success){
            [SVProgressHUD dismiss];
            arrayDiehardsNews = [result valueForKey:@"DiehardsNews"];
            arrayTopAnalysis = [result valueForKey:@"TopAnalysis"];
            arrayFAMovements = [result valueForKey:@"FAMovements"];
            arrayNewsAndViews = [result valueForKey:@"NewsAndViews"];
            arrayHeadlineNewsAnalysis = [result valueForKey:@"BreakNews"];
            arrayFantasyColumnWriters = [result valueForKey:@"FantasyColumnWriters"];
            arrayFantasyLatestColumns = [result valueForKey:@"FantasyLatestColumns"];
            [arrayHomeAllData addObjectsFromArray:@[arrayDiehardsNews, arrayTopAnalysis, arrayFAMovements,arrayNewsAndViews,arrayHeadlineNewsAnalysis,arrayFantasyColumnWriters,arrayFantasyLatestColumns]];
            [self.tableViewHomeDetails reloadData];
        }
        else{
            [SVProgressHUD dismiss];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                     message:error.localizedDescription
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionOK];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark Tap Gesture function
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [[ARExpandableSideMenu sharedInstance] hideSideMenu];
}

#pragma mark Tableview delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayHomeAllData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section)
    {
        case 0:
            return arrayDiehardsNews.count;
            break;
        case 1:
            return arrayTopAnalysis.count;
            break;
        case 2:
            return arrayFAMovements.count;
            break;
        case 3:
            return arrayNewsAndViews.count;
            break;
        case 4:
            return arrayHeadlineNewsAnalysis.count;
            break;
        case 5:
            return arrayFantasyColumnWriters.count;
            break;
        case 6:
            return arrayFantasyLatestColumns.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self headerViewForDiehardsNewsAndViews];
            break;
        case 1:
            return [self headerViewWithLabel:@"TOP ANALYSIS" withFontSize:15 withBgColour:[UIColor whiteColor]];
             break;
        case 2:
            return self.viewFAMovementHeader;
             break;
        case 3:
            return [self headerViewWithLabel:@"***** ****** News & Views" withFontSize:15 withBgColour:[UIColor colorWithRed:0.972 green:0.949 blue:0.505 alpha:1]];
            break;
        case 4:
            return [self headerViewWithLabel:@"***** ****** Headline News Analysis" withFontSize:14 withBgColour:[UIColor colorWithRed:0.972 green:0.949 blue:0.505 alpha:1]];
            break;
        case 5:
            return [self headerViewWithLabel:@"***** ****** Columns" withFontSize:15 withBgColour:[UIColor whiteColor]];
            break;
        case 6:
            return self.viewFantasyLatestColumnsHeader;
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 50;
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 55;
            break;
        case 3:
            return 40;
            break;
        case 4:
            return 40;
            break;
        case 5:
            return 40;
            break;
        case 6:
            return 40;
            break;
        default:
            break;
    }
    return 0;
}

// Multiple cells are creating here
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        NewsTableViewCell * newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        if (newsCell == nil){
            newsCell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
        }
        [newsCell setNewsDetails:arrayDiehardsNews[indexPath.row]];
        return newsCell;
    }
    else if (indexPath.section == 1){
        TopAnalysisTableViewCell *topAnalysisCell = [tableView dequeueReusableCellWithIdentifier:@"TopAnalysisCell"];
        if (topAnalysisCell == nil) {
            topAnalysisCell = [[TopAnalysisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopAnalysisCell"];
        }
        [topAnalysisCell setTopAnalysisDetails:arrayTopAnalysis[indexPath.row]];
        return topAnalysisCell;
    }
    else if (indexPath.section == 2){
        FAMovementTableViewCell *faMovementCell = [tableView dequeueReusableCellWithIdentifier:@"FAMovementCell"];
        if (faMovementCell == nil) {
            faMovementCell = [[FAMovementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FAMovementCell"];
        }
        [faMovementCell setFAMovementDetails:arrayFAMovements[indexPath.row]];
        return faMovementCell;
    }
    else if (indexPath.section == 3){
        NewsAndViewsTableViewCell *newsAndViewsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsAndViewsCell"];
        if (newsAndViewsCell == nil) {
            newsAndViewsCell = [[NewsAndViewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsAndViewsCell"];
        }
        [newsAndViewsCell setNewsAndViewsDetails:arrayNewsAndViews[indexPath.row]];
        return newsAndViewsCell;
    }
    else if (indexPath.section == 4){
        HeadlineNewsAnalysisTableViewCell *headlineNewsAnalysisCell = [tableView dequeueReusableCellWithIdentifier:@"HeadlineNewsAnalysisCell"];
        if (headlineNewsAnalysisCell == nil) {
            headlineNewsAnalysisCell = [[HeadlineNewsAnalysisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadlineNewsAnalysisCell"];
        }
        [headlineNewsAnalysisCell setHeadlineAndNewsAnalysis:arrayHeadlineNewsAnalysis[indexPath.row]];
        return headlineNewsAnalysisCell;
    }
    else if (indexPath.section == 5){
        FantasyColumnWritersTableViewCell *fantasyColumnWritersCell = [tableView dequeueReusableCellWithIdentifier:@"FantasyColumnWritersCell"];
        if (fantasyColumnWritersCell == nil) {
            fantasyColumnWritersCell = [[FantasyColumnWritersTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FantasyColumnWritersCell"];
        }
        [fantasyColumnWritersCell setFantasyColumnWritersDetails:arrayFantasyColumnWriters[indexPath.row]];
        return fantasyColumnWritersCell;
    }
    else if (indexPath.section == 6){
        FantasyLatestColumnsTableViewCell *fantasyLatestColumnsCell = [tableView dequeueReusableCellWithIdentifier:@"FantasyLatestColumnsCell"];
        if (fantasyLatestColumnsCell == nil) {
            fantasyLatestColumnsCell = [[FantasyLatestColumnsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FantasyLatestColumnsCell"];
        }
        [fantasyLatestColumnsCell setFantasyLatestColumnsDetails:arrayFantasyLatestColumns[indexPath.row]];
        return fantasyLatestColumnsCell;
    }
    return  nil;
}


// The height for each row in different section is managed here.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dataDictionary = arrayDiehardsNews[indexPath.row];
        NSString *stringFacts = [NSString stringWithFormat:@"The Facts: %@",[dataDictionary valueForKey:@"facts"]];
        NSString *stringCompanyLine = [NSString stringWithFormat:@"Diehards Line: %@",[dataDictionary valueForKey:@"company_line"]];
        NSMutableAttributedString *attStringFacts = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\r\r%@", stringFacts,stringCompanyLine]];
        return 227 + [GenericFunctions heightForLabelWithAttributedString:attStringFacts font:[UIFont systemFontOfSize:14] width:self.view.frame.size.width-10];
    }
    else if (indexPath.section == 1){
        return 72;
    }
    else if (indexPath.section == 2){
        return 25;
    }
    else if (indexPath.section == 3){
        return 72;
    }
    else if (indexPath.section == 4){
        NSDictionary *dataDictionary = arrayHeadlineNewsAnalysis[indexPath.row];
        if ([[dataDictionary valueForKey:@"player_photo"] isEqualToString:@""] && [[dataDictionary valueForKey:@"story"] isEqualToString:@""]) {
            return 35;
        }
        else if (!([[dataDictionary valueForKey:@"story"] isEqualToString:@""])){
            return 170 + [GenericFunctions heightForLabelWithString:[dataDictionary valueForKey:@"story"] font:[UIFont systemFontOfSize:13] width:self.view.frame.size.width-10];
        }
        return 226;
    }
    else if (indexPath.section == 5){
        return 60;
    }
    else if (indexPath.section == 6){
        return 50;
    }
    return 0;
}


// The sections for the table are managed here.
#pragma mark Section headers views
-(UIView *)headerViewForDiehardsNewsAndViews{
    UIView *viewDiehardsNewsAndViews = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, 50)];
    viewDiehardsNewsAndViews.backgroundColor = [UIColor whiteColor];
    UILabel *lblNewsAndViews = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(viewDiehardsNewsAndViews.frame), 0, CGRectGetWidth(viewDiehardsNewsAndViews.frame), 40)];
    lblNewsAndViews.numberOfLines = 0;
    lblNewsAndViews.font = [UIFont boldSystemFontOfSize:13];
    lblNewsAndViews.text = @"Free ***** ****** - ***** ****** And Views";
    lblNewsAndViews.textAlignment = NSTextAlignmentCenter;
    [viewDiehardsNewsAndViews addSubview:lblNewsAndViews];
    UILabel *lblSeprator = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(viewDiehardsNewsAndViews.frame), CGRectGetMaxY(lblNewsAndViews.frame)+5  , CGRectGetWidth(viewDiehardsNewsAndViews.frame), 5)];
    lblSeprator.backgroundColor = [UIColor redColor];
    [viewDiehardsNewsAndViews addSubview:lblSeprator];
    return viewDiehardsNewsAndViews;
}

-(UIView *)headerViewWithLabel:(NSString *)strHeaderLabel withFontSize:(CGFloat)fontSize withBgColour:(UIColor *)bgColour{
    UIView *viewGenericHeader = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, 40)];
    //viewGenericHeader.backgroundColor = [UIColor colorWithRed:0.972 green:0.949 blue:0.505 alpha:1];
    viewGenericHeader.backgroundColor = bgColour;
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(viewGenericHeader.frame), 0, CGRectGetWidth(viewGenericHeader.frame), 40)];
    lblHeader.numberOfLines = 0;
    lblHeader.font = [UIFont boldSystemFontOfSize:fontSize];
    lblHeader.text = strHeaderLabel;
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.textColor = [UIColor colorWithRed:0.011 green:0.137 blue:0.537 alpha:1];
    [viewGenericHeader addSubview:lblHeader];
    return viewGenericHeader;
}

@end
