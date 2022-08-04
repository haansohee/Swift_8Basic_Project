//
//  ViewController.swift
//  Calculator
//
//  Created by 한소희 on 2022/08/04.
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown  // 아무 연산도 아니란 뜻
}

class ViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    // View Controller의 계산기 상태 값을 가지고 있는 프로퍼티들
    var displayNumber = "" // 계산기 버튼을 누를 때마다 넘버 아웃풋 Label에 표시되는 숫자
    var firstOperand = ""  // 이전 계산 값을 저장하는 프로퍼티. 첫번째 피연산자
    var secondOperand = ""  // 새롭게 입력된 값을 저장하는 프로퍼티. 두번째 피연산자
    var result = ""  // 계산의 결과값을 저장하는 프로퍼티.
    var currentOperation: Operation = .unknown  // 현재 계산기에 어떤 연산자가 입력되어 있는지 알 수 있게 연산자 값을 저장하는 프로퍼티.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func tapNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.titleLabel?.text else { return }
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
        
        // sender.title : 선택한 버튼의 title 값을 가지고 옴
        guard let numberValue = sender.title(for: .normal) else { return }
        // 선택된 숫자값을 displayNumber에 문자열로 계속 추가될 수 있고, 9자리까지만 입력될 수 있게.
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tabDotButton(_ sender: UIButton) {
        // 숫자 8자리 입력하고 소수점 선택 뒤 숫자를 입력하면 소수점 포함 10자리가 표시되니까 소수점 포함 9자리가 될 수 있게 예외 처리
        // 소수점이 중복으로 찍히면 안 되니까 "."이 포함되지 않은 경우의 조건도 추가해 줌.
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tabEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    // 연산자 버튼을 눌렀을 때 numberOutputLabel에 표시
    // 계산 함수
    func operation (_ operation: Operation) {
        if self.currentOperation != .unknown {  // 첫번째 피연산자와 두번째 피연산자를 연산
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                 
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                    
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                    
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                    
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                    
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            
            self.currentOperation = operation
        }
        else {  // unknown이라면, 계산기가 초기화된 상태에서 사용자가 첫번째 피연산자와 연산자를 선택한 상태일 것임.
            self.firstOperand = self.displayNumber  // 화면에 표시된 숫자가 첫번째 피연산자가 될 것임.
            self.currentOperation = operation  // 선택한 연산자 저장.
            self.displayNumber = ""
        }
    }
}

