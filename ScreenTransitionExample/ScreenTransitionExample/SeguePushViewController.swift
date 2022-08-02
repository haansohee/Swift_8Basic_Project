//
//  SeguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 한소희 on 2022/08/02.
//

import UIKit

class SeguePushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        /*
        self.navigationController?.popToRootViewController(animated: true)  // Back Button을 눌렀을 때 네비게이션 컨트롤러의 첫 화면인 Root View Controller로 이동하게 됨. */
    }
}
