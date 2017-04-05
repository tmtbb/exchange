//
//  ScanVC.swift
//  wp
//
//  Created by sum on 2017/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class ScanVC: BaseTableViewController {

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    
    @IBOutlet weak var chooseImgBtn: UIButton!
    @IBOutlet weak var selectImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ShareModel.share().chooseUploadImg == 100 ? "上传营业执照扫描件" : "上传法人有效身份证件"
        
        selectImg.clipsToBounds = true
        selectImg.layer.cornerRadius = 5
        selectImg.layer.borderWidth = 1
        selectImg.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        chooseImgBtn.setTitle(ShareModel.share().chooseUploadImg == 100 ? "上传营业执照扫描件" : "上传法人有效身份证件", for: .normal)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func uploadImg(_ sender: Any) {
        
        
    }
   
    @IBAction func chooseImg(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present((imagePicker), animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


}
extension ScanVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
//        userImage.image = image
        UIImage.qiniuUploadImage(image: image, imageName: "\(Int(Date.nowTimestemp()))", complete: { (result) -> ()? in
            
            print(result!)
            //七牛请求回来url地址  上传到服务器.成功之后.保存到UserModel.share().getCurrentUser()?.avatarLarge 在通知 更新UI
            
            return nil
        }) { (error) -> ()? in
            print(error)
            return nil
        }
    }
}
