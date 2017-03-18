//
//  ViewController.m
//  身份证识别
//
//  Created by Gzedu on 2017/3/13.
//  Copyright © 2017年 Gzedu. All rights reserved.
//

#import "ViewController.h"
#import <TesseractOCR/TesseractOCR.h>
#import "UIImage+extension.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImagePickerController *pickerVC;


@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *recoginLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickerVC = [[UIImagePickerController alloc]init];
    _pickerVC.delegate = self;
}

- (IBAction)photographClick:(UIButton *)sender {
    //判断是否可以开启照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //设置摄像头为拍照模式
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:_pickerVC animated:YES completion:^{
            
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不能打开相机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate
//获取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = nil;
    if ([mediaType isEqualToString:@"public.image"]) {
        srcImage = info[UIImagePickerControllerOriginalImage];
        
        self.imageV.image = [UIImage scaleImageWithImage:srcImage dimension:200];
        //识别身份证
        [self tesseractRecogniceWithImage:srcImage compleate:^(NSString *text) {
            if (text != nil) {

                self.recoginLab.text = [NSString stringWithFormat:@"识别的文字为%@",text];
                NSLog(@"%@",[NSThread currentThread]);
                NSLog(@"%@",text);
            }else{
                self.recoginLab.text = @"请重新拍照";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片识别失败，请选择清晰、没有复杂背景的身份证照片重试！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }
        }];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tesseractRecogniceWithImage:(UIImage *)image compleate:(void(^)(NSString *text))compleate {
        G8Tesseract *tesseract = [[G8Tesseract alloc]initWithLanguage:@"eng"];
        //模式
        tesseract.engineMode = G8OCREngineModeTesseractOnly;
        tesseract.maximumRecognitionTime = 10;
        tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
        tesseract.image = [image g8_blackAndWhite];
    
        [tesseract recognize];
        compleate(tesseract.recognizedText);
}
@end
