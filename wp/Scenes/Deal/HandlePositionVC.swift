//
//  HandlePositionVC.swift
//  wp
//
//  Created by J-bb on 17/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class HandlePositionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissController()
    }
    @IBAction func freightAction(_ sender: Any) {
        dismissController()

    }
    @IBAction func feeRefundAction(_ sender: Any) {
        dismissController()

    }
    @IBAction func resellAction(_ sender: Any) {
        dismissController()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
