//
//  LCESetIconViewController.m
//  iTimerDiary
//
//  Created by tarena on 15/12/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCESetIconViewController.h"
#import "UIButton+LCESetBtnImage.h"
#import "LCEButton.h"




@interface LCESetIconViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *kindButton;
@property (nonatomic, strong) UIButton *paperButton;
@property (nonatomic, strong) UIButton *weatherButton;

@property (nonatomic, strong) NSString *selectBgImageName;

@property (nonatomic, strong) UIImage *kindImage;
@property (nonatomic, strong) NSString *kindImageName;
@property (nonatomic, strong) UIImage *paperImage;
@property (nonatomic, strong) NSString *paperImageName;
@property (nonatomic, strong) UIImage *weatherImage;
@property (nonatomic, strong) NSString *weatherImageName;


@end
static NSString *reuseIdentifier = @"collectionViewCell";

@implementation LCESetIconViewController
- (UIImage *)kindImage {
    if (!_kindImage) {
        _kindImage = [UIImage new];
    }
    return _kindImage;
}
- (UIImage *)paperImage {
    if (!_paperImage) {
        _paperImage = [UIImage new];
    }
    return _paperImage;
}
- (UIImage *)weatherImage {
    if (!_weatherImage) {
        _weatherImage = [UIImage new];
    }
    return _weatherImage;
}

- (NSString *)selectBgImageName {
    if (!_selectBgImageName) {
        _selectBgImageName = @"paper_select";
    }
    return _selectBgImageName;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.weatherImage = [UIImage imageNamed:@"look_weather1"];
    
    self.kindImage = [UIImage imageNamed:@"diary_face1"];
    
}
- (IBAction)clickBackOrCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---- 实现cell的协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            self.tableView.rowHeight = 130;
            
            
            

            UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
            flow.itemSize = CGSizeMake(50, 50);
            flow.minimumLineSpacing = 5;
            flow.minimumInteritemSpacing = 2;
            flow.scrollDirection = UICollectionViewScrollDirectionVertical;
            flow.sectionInset = UIEdgeInsetsMake(15, 20, 10, 20);
            
            
            
            
            UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130) collectionViewLayout:flow];
            collectView.tag = 100;
            [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
            collectView.delegate = self;
            collectView.dataSource = self;
            collectView.allowsMultipleSelection=YES;
            collectView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:collectView];
            break;
        }
        case 1: {
            self.tableView.rowHeight = 135;

            UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
            flow.itemSize = CGSizeMake(50, 50);
            flow.minimumLineSpacing = 5;
            flow.minimumInteritemSpacing = 2;
            flow.scrollDirection = UICollectionViewScrollDirectionVertical;
            flow.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20);
            
            
            UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 135) collectionViewLayout:flow];
            collectView.tag = 101;
            [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
            collectView.delegate = self;
            collectView.dataSource = self;
            collectView.allowsMultipleSelection=YES;
            collectView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:collectView];
            break;
        }
        case 2: {
            
            self.tableView.rowHeight = 180;

            UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
            flow.itemSize = CGSizeMake((self.view.bounds.size.width-80)/6, 40);
            flow.minimumLineSpacing = 8;
            flow.minimumInteritemSpacing = 10;
            flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flow.sectionInset = UIEdgeInsetsMake(20, 20,20, 20);
            
            
            // 1.创建pageControl的实例
            UIPageControl *pageControl = [[UIPageControl alloc]init];
            
            self.pageControl = pageControl;
            
            // 2.设置pageControl的frame
            pageControl.frame = CGRectMake(0, cell.bounds.size.height+ 31, cell.bounds.size.width, 10);
            
            // 3.添加pageControl到控制器的view中
            [cell addSubview:pageControl];
            
            // 4.配置pageControl
            pageControl.numberOfPages = 8;
            
            // 5.配置提示符的颜色
            pageControl.pageIndicatorTintColor = [UIColor blackColor];
            
            // 6.配置选中的提示符的颜色
            pageControl.currentPageIndicatorTintColor = [UIColor redColor];
            
            // 7.关闭圆点与用户的交互功能
            pageControl.userInteractionEnabled = NO;
            
            
            
            
            UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) collectionViewLayout:flow];
            collectView.tag = 102;
            [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
            collectView.delegate = self;
            collectView.dataSource = self;
            collectView.pagingEnabled = YES;
            collectView.allowsMultipleSelection=YES;
            collectView.showsHorizontalScrollIndicator = NO;
            collectView.bounces = NO;
            
            
            collectView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:collectView];
            
            break;
            
        }
            
        default:
            break;
    }
    return cell;
    
}

#pragma mark - UIScrollViewDelegate 协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int index = round(scrollView.contentOffset.x / self.view.bounds.size.width);
    
    self.pageControl.currentPage = index;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str = nil;
    if (section == 0) {
        str = @"天气";
    } else if (section == 1) {
        str = @"心情";
    } else {
        str = @"贴图";
    }
    return str;
}


//设置区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}


#pragma mark ---- colletionViewCell的协议方法实现
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == 100) {
        return 1;
    }else if (collectionView.tag == 101) {
        return 1;
    }else {
        return 8;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 100) {
        return 7;
    } else if (collectionView.tag == 101) {
        return 10;
    } else {
        return 18;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 100) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        UIButton * button = [[UIButton alloc] init];
        NSString * imageName = [[NSString alloc] init];
        NSString * selectedImageName = [[NSString alloc] init];
        
        imageName = [NSString stringWithFormat:@"look_weather%ld", indexPath.row + 1];
        selectedImageName = [NSString stringWithFormat:@"look_weather%ld_select", indexPath.row + 1];
        button = [UIButton buttonWithImageName:imageName withSelectedImageName:selectedImageName withTarget:self withAction:@selector(clickweatherButton:)];
        
        button.tag = indexPath.row;
        [cell.contentView addSubview:button];
        
        
        return cell;
    } else if (collectionView.tag == 101) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        UIButton * button = [[UIButton alloc] init];
        NSString * imageName = [[NSString alloc] init];
        NSString * selectedImageName = [[NSString alloc] init];
        
        imageName = [NSString stringWithFormat:@"diary_face%ld", indexPath.row + 1];
        selectedImageName = [NSString stringWithFormat:@"diary_face%ld_select", indexPath.row + 1];
        button = [UIButton buttonWithImageName:imageName withSelectedImageName:selectedImageName withTarget:self withAction:@selector(clickKindButton:)];
        button.tag = indexPath.row;
        [cell.contentView addSubview:button];
        
        return cell;
        
    } else {
        
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        
        
        
        LCEButton *button = [cell.contentView viewWithTag:10];
        
        if (button == nil) {
            button = [[LCEButton alloc] init];
            button.tag = 10;
            button.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
            [cell.contentView addSubview:button];
        }
        button.flag = indexPath.row;
        button.indexPath = indexPath.section;
        if (indexPath.section == 0) {
            
            NSString *imageName = [NSString stringWithFormat:@"one%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else if (indexPath.section == 1) {
            
            NSString *imageName = [NSString stringWithFormat:@"two%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else if (indexPath.section == 2) {
            
            NSString *imageName = [NSString stringWithFormat:@"three%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else if (indexPath.section == 3) {
            
            NSString *imageName = [NSString stringWithFormat:@"four%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else if (indexPath.section == 4) {
            
            NSString *imageName = [NSString stringWithFormat:@"five%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else if (indexPath.section == 5) {
            
            NSString *imageName = [NSString stringWithFormat:@"six%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else if (indexPath.section == 6) {
            
            NSString *imageName = [NSString stringWithFormat:@"women_face%ld", indexPath.row + 1];
            
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }else {
            
            NSString *imageName = [NSString stringWithFormat:@"man_face%ld", indexPath.row + 1];
            [button buttonWithImageName:imageName withSelectBgImageName:self.selectBgImageName withTarget:self withAction:@selector(clickPaperButton:)];
        }
        
        
        
        button.selected = NO;
        //设置
        self.paperButton = nil;
        return cell;
        
    }
    
    
}


- (void)clickweatherButton:(UIButton *)button {
    self.weatherImage = button.currentImage;
    self.weatherImageName = [NSString stringWithFormat:@"look_weather%ld", button.tag + 1];
    button.selected = !button.selected;
    if (self.weatherButton) {
        self.weatherButton.selected = !self.weatherButton.selected;
    }
    
    self.weatherButton = button;
}
- (void)clickKindButton:(UIButton *)button {
    self.kindImage = button.currentImage;
    self.kindImageName = [NSString stringWithFormat:@"diary_face%ld", button.tag + 1];
    button.selected = !button.selected;
    if (self.kindButton) {
        
        self.kindButton.selected = !self.kindButton.selected;
    }
    self.kindButton = button;
}
- (void)clickPaperButton:(LCEButton *)button {
    self.paperImage = button.currentImage;
    
    if (button.indexPath == 0) {
        self.paperImageName = [NSString stringWithFormat:@"one%ld", button.flag + 1];
    }
    else if (button.indexPath == 1) {
        self.paperImageName = [NSString stringWithFormat:@"two%ld", button.flag + 1];
    }
    else if (button.indexPath == 2) {
        self.paperImageName = [NSString stringWithFormat:@"three%ld", button.flag + 1];
    }
    else if (button.indexPath == 3) {
        self.paperImageName = [NSString stringWithFormat:@"four%ld", button.flag + 1];
    }
    else if (button.indexPath == 4) {
        self.paperImageName = [NSString stringWithFormat:@"five%ld", button.flag + 1];
    }
    else if (button.indexPath == 5) {
        self.paperImageName = [NSString stringWithFormat:@"six%ld", button.flag + 1];
    }
    else if (button.indexPath == 6) {
        self.paperImageName = [NSString stringWithFormat:@"women_face%ld", button.flag + 1];
    }
    else {
        self.paperImageName = [NSString stringWithFormat:@"man_face%ld", button.flag + 1];
    }
    
    button.selected = !button.selected;
    if (self.paperButton) {
        self.paperButton.selected = !self.paperButton.selected;
    }
    self.paperButton = button;
}

/* 配置分页控件 *///（小圆点）
-(void) setUpPageControl
{
    // 1.创建pageControl的实例
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    self.pageControl = pageControl;
    
    // 2.设置pageControl的frame
    pageControl.frame = CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 30);
    
    // 3.添加pageControl到控制器的view中
    [self.view addSubview:pageControl];
    
    // 4.配置pageControl
    pageControl.numberOfPages = 4;
    
    // 5.配置提示符的颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    // 6.配置选中的提示符的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 7.关闭圆点与用户的交互功能
    pageControl.userInteractionEnabled = NO;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}





- (IBAction)clickSaveButton:(id)sender {
    
    [self.delegate lceSetIconViewController:self didFinishSelectedWeatherImage:self.weatherImage withImageName:self.weatherImageName];
    [self.delegate lceSetIconViewController:self didFinishSelectedKindImage:self.kindImage withImageName:self.kindImageName];
    [self.delegate lceSetIconViewController:self didFinishSelectedPaperImage:self.paperImage withImageName:self.paperImageName];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.paperImage = nil;
    
}




@end
