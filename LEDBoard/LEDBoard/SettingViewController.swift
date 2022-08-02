//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by 한소희 on 2022/08/02.
//

import UIKit

protocol LEDBoardSettingDelegate: AnyObject {
    // 설정값을 전달하는 함수
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var oragneButton: UIButton!
    
    weak var delegate: LEDBoardSettingDelegate?
    var ledText: String?
    
    // 설정된 값을 델리게이트에 정의한 changedSetting 메서드에 전달하기 위해 이 텍스트컬러와 백그라운드컬러 프로퍼티를 추가하겠음
    var textColor: UIColor = .yellow
    var backgroungColor: UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // 다시 설정 뷰로 돌아갔을 때도 설정한 값들이 유지되도록 하는 함수
    private func configureView() {
        if let ledText = self.ledText {
            self.textField.text = ledText
        }
        self.changeTextColor(color: self.textColor)
        self.changeBackgroundColorButton(color: self.backgroungColor)
    }
    
    @IBAction func tabTextColorButton(_ sender: UIButton) {
        if sender == self.yellowButton
        {
            self.changeTextColor(color: .yellow)
            self.textColor = .yellow
        }
        else if sender == self.purpleButton
        {
            self.changeTextColor(color: .purple)
            self.textColor = .purple
        }
        else if sender == self.greenButton
        {
            self.changeTextColor(color: .green)
            self.textColor = .green
        }
    }
    
    @IBAction func tabBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton
        {
            self.changeBackgroundColorButton(color: .black)
            self.backgroungColor = .black
        }
        else if sender == self.blueButton
        {
            self.changeBackgroundColorButton(color: .blue)
            self.backgroungColor = .blue
        }
        else if sender == self.oragneButton
        {
            self.changeBackgroundColorButton(color: .orange)
            self.backgroungColor = .orange
        }
    }
    
    @IBAction func tabSaveButton(_ sender: UIButton) {
        self.delegate?.changedSetting(
            text: self.textField.text,
            textColor: textColor,
            backgroundColor: backgroungColor
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    private func changeTextColor(color: UIColor) {
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
    }
    
    private func changeBackgroundColorButton(color: UIColor) {
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.oragneButton.alpha = color == UIColor.orange ? 1 : 0.2
    }
}
