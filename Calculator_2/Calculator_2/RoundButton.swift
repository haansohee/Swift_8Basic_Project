//
//  RoundButton.swift
//  Calculator
//
//  Created by 한소희 on 2022/08/04.
//

import UIKit

// 변경한 값을 실시간으로 스토리 보드에서 볼 수 있게 @IBDesignable 선언
@IBDesignable
class RoundButton: UIButton { // UIButton을 상속한 RoundButton. 기존 UIButton 들의 속성들을 그대로 사용 가능, 추가적으로 사용자가 원하는 속성들을 이 클래스에 만들어 사용 가능.
    @IBInspectable var isRound: Bool = false {  // 스토리 보드에서도 isRound의 설정 값을 변경할 수 있게 @IBInspectable
        didSet
        {
            if isRound
            {
                self.layer.cornerRadius = self.frame.height / 2  // 정사각형 버튼 : 원, 정사각형이 아닌 버튼은 모서리가 둥글게
            }
        }
    }
}
