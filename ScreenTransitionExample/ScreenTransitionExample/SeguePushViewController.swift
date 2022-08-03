//
//  SeguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 한소희 on 2022/08/02.
//

import UIKit

class SeguePushViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String?
    
    // 전환되는 화면에 값을 전달하기 위한 젤 좋은 위치 : 전처리 prepare 메서드(오버라이드 하면 세그웨이를 실행 직전에 시스템에 의해 자동 호출됨)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        /*
        self.navigationController?.popToRootViewController(animated: true)  // Back Button을 눌렀을 때 네비게이션 컨트롤러의 첫 화면인 Root View Controller로 이동하게 됨. */
    }
}
