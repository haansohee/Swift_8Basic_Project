//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by 한소희 on 2022/08/02.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController 뷰가 로드되었음.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController 뷰가 나타날 것임.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController 뷰가 나타났음.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController 뷰가 사라질 것임.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewController 뷰가 사라졌음.")
    }

    @IBAction func tabCodePushButton(_ sender: UIButton) {
        // 우선 스토리 보드에 있는 뷰 컨트롤러를 인스턴스화 해 주어야 함.
        
        // 이 메서드에 전환되는 화면의 뷰 컨트롤러 클래스 타입으로 다운 캐스팅 해줌
        // => 아까 CodePush / CodePresentViewController에 정의한 name 프로퍼티에 접근 가능. 그러면 다른 화면으로 푸쉬와 프레젠트 되기 전에 네임 프로퍼티에 값을 넘겨주면 전환된 화면으로 데이터를 전달할 수 있음
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else { return } // Identifier => 전환할 스토리보드 아이디
        // 옵셔널로 반환하기 때문에 가드문으로 처리해야 함.
        
        viewController.name = "Sohee"
        self.navigationController?.pushViewController(viewController, animated: true)
        // 액션 함수 안에서 네비게이션 스택에 코드푸쉬뷰컨트롤러가 푸쉬 되게 코드 작성
    }
    
    @IBAction func tabCodePresentButton(_ sender: UIButton) {
        // 마찬가지로 스토리 보드에 있는 뷰 컨트롤러를 인스턴스화 해 주어야 함.
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else { return }
        viewController.name = "Sohee"
        viewController.delegate = self  // self로 초기화하면 델리게이트를 위임받게 됨.
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sendData(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()  // 텍스트에 맞게 Label 사이즈 조정.
    }
}
