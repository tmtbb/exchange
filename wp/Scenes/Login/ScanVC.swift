//
//  ScanVC.swift
//  wp
//
//  Created by sum on 2017/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class ScanVC: BaseTableViewController {
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    
    @IBOutlet weak var identityCardBackbtn: UIButton!
    @IBOutlet weak var identityCardback: UIImageView!
    @IBOutlet weak var chooseImgBtn: UIButton!
    @IBOutlet weak var selectImg: UIImageView!
    
    var type : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ShareModel.share().chooseUploadImg == 100 ? "上传营业执照扫描件" : "上传法人有效身份证件"
        
        selectImg.clipsToBounds = true
        
        identityCardback.layer.cornerRadius = 5
        identityCardback.layer.borderWidth = 1
        identityCardback.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        selectImg.layer.cornerRadius = 5
        selectImg.layer.borderWidth = 1
        selectImg.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        chooseImgBtn.setTitle(ShareModel.share().chooseUploadImg == 100 ? "上传营业执照扫描件" : "上传法人有效身份证件正面", for: .normal)
        identityCardBackbtn.setTitle(ShareModel.share().chooseUploadImg == 100 ? "上传营业执照扫描件" : "上传法人有效身份证件反面", for: .normal)
        imagePicker.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func uploadImg(_ sender: Any) {
        
        
        SVProgressHUD.show(withStatus: "上传中")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let data = UIImageJPEGRepresentation(self.selectImg.image! , 0.5)
            
            
            multipartFormData.append(data!, withName: "file", fileName: "file", mimeType: "image/png")
            //            let param = ["appVersion" :"iOS" , "osType" : "0","timestamp":"\(timeInterval)","keyId":"\(keyid)"]
            
            if (self.identityCardback.image != nil) {
                let data = UIImageJPEGRepresentation(self.identityCardback.image! , 0.5)
                
                
                multipartFormData.append(data!, withName: "file", fileName: "file", mimeType: "image/png")
            }
            let model = HttpRequestModel()
            
            let param = ( model.toDictionary()) as! Dictionary<String, Any>
            for (key, value) in param {
                let str = "\(value)"
                multipartFormData.append(str.data(using: .utf8)!, withName: key)
            }
            
        }, to: AppConst.Network.TttpHostUrl + "/api/file/upload.json") { (response) in
            let encodingResult = response as! SessionManager.MultipartFormDataEncodingResult
             SVProgressHUD.dismiss()
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let myJson = response.result.value {
                        let jsonDict = myJson as! Dictionary<String, Any>
                        if let status = jsonDict["status"] as? Int{
                            if status == 0{
                                SVProgressHUD.showSuccess(withStatus: "上传成功")
                                if ShareModel.share().chooseUploadImg == 100{
                                    
                                    if let resData = jsonDict["data"] {
                                        
                                        
                                        let arr  =  resData as! Array<Dictionary<String, Any>>
                                        
                                        for  dic in arr {
                                            UserModel.share().companyImg = dic["url"] as! String
                                        }
                                        
                                    }
                                    
                                }
                                else {
                                    
                                    if let resData = jsonDict["data"] {
                                        
                                        
                                        let arr  =  resData as! Array<Dictionary<String, Any>>
                                        
                                        for i in 0..<arr.count{
                                            let dic = arr[i]
                                            if i == 0 {
                                                UserModel.share().identityCardBack = dic["url"] as! String
                                            }
                                            if i == 1 {
                                                UserModel.share().identityCardJust = dic["url"] as! String
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        self.perform(#selector(self.registSuccess), with: self, afterDelay: 2)
                        let _ = self.navigationController?.popViewController(animated: true)
                        
                        
                        
                    }
                })
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    func registSuccess(){
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func chooseImg(_ sender: Any) {
        type = 0
        imagePicker.sourceType = .photoLibrary
        present((imagePicker), animated: true, completion: nil)
    }
    @IBAction func identityCardBack(_ sender: Any) {
        
        type = 1
        imagePicker.sourceType = .photoLibrary
        present((imagePicker), animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1{
            
            return  ShareModel.share().chooseUploadImg == 100 ? 0.01 : 181
        }
        return 181
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  3
    }
    
    
}
extension ScanVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        if type == 0 {
            selectImg.image = image
            chooseImgBtn.setTitle("", for: .normal)
            
            
        }else{
            
            identityCardback.image = image
            identityCardBackbtn.setTitle("", for: .normal)
            
        }
        //        selectImg.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        //        userImage.image = image
        
    }
}
