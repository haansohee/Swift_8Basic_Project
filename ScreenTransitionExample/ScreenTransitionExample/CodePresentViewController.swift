//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 한소희 on 2022/08/02.
//

import UIKit

protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    weak var delegate: SendDataDelegate?  // weak 키워드, 델리게이트 패턴 사용할 땐 delegate 변수 앞에 붙여줘야함. 메모리 누수 방지를 위해서!
    // 델리게이트 선언 완료 -> 델리게이트 변수는 이를 위임할 준비를 완료한 것

    override func viewDidLoad() {
        super.viewDidLoad()
        // 전달받은 name 프로퍼티를 nameLabel에 표시.
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }

    @IBAction func tabBackButton(_ sender: UIButton) {
        self.delegate?.sendData(name: "HanSohee")  // 데이터를 전달받은 뷰 컨트롤러에서 sendData 델리게이트 Protocol을 채택하고, 델리게이트를 위임받게 되면 채택하기 이전 화면에서 뷰 컨트롤러에서 정의된 센드데이터함수가 실행됨.
        self.presentingViewController?.dismiss(animated: true)
    }
}
