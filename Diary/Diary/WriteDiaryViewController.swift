//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 한소희 on 2022/08/23.
//

import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

// delegate를 통해서 일기장 리스트 화면에 일기가 작성된 Diary객체를 전달.
protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)  // 이 메서드에 일기가 작성된 Diary 객체를 전달할 것임.
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?  // DatePicker에서 선택된 날짜를 저장하는 프로퍼티.
    weak var delegate: WriteDiaryViewDelegate?
    
    //DiaryEditorMode를 저장하는 프로퍼티
    var diaryEditroMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        self.confirmButton.isEnabled = false  // 등록버튼을 비활성화되게 설정.
    }
    
    private func configureEditMode() {
        switch self.diaryEditroMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
            
        default:
            break
        }
    }
    
    // 데이트 타입을 전달받으면 문자열로 만들어 주는 함수
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor  // 레이어 관련 색상 설정할 때는 UIColor가 아닌 cgColor로 설정해야 함.
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
        // layer에 접근해서 borderColor와 borderWidth 프로퍼티를 설정하면 뷰의 테두리를 만들 수 있음.
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = self.datePicker
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)  // 제목 텍스트 필드에 텍스트가 입력될 때마다 titleTextFieldDidChange() 호출
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        // (tapConfirmButton 액션 함수가 호출될 때) 일기를 다 작성하고 등록 버튼을 눌렀을 때, Diary 객체를 생성하고 델리게이트에 정의한 didSelectRegister 메서드 호출해서 메서드 파라미터에 생성된 Diary 객체를 전달시켜줌.
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        self.delegate?.didSelectRegister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()  // DateFormatter객체는 날짜와 텍스트를 반환해 주는 역할. 데이트 타입을 사람이 읽을 수 있는 형태의 문자열로 변환시켜주거나 그 반대의 역할을 함.
        formatter.dateFormat =  "yyyy년 MM월 dd일(E)"
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()  // 날짜가 변경될 때마다 등록 버튼 활성화 여부를 판단할 수 있게 구현.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 등록 버튼의 활성화 여부를 판단하는 메서드
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty  // 즉, 모든 InputField가 비어 있지 않으면 등록 버튼이 활성화되게 구현
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {  // 텍스트뷰에 텍스트가 입력될 때마다 호출되는 메서드.
        self.validateInputField()
    }
}
