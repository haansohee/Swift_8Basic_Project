//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 한소희 on 2022/08/23.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: DiaryDetailViewDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)

    }
    
    // 데이트 타입을 전달받으면 문자열로 만들어 주는 함수
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) { // 수정된 다이어리 객체를 전달받아서 뷰에 업데이트하기.
        guard let diary = notification.object as? Diary else { return }  // Diary 타입으로 다운 캐스팅.
        // 포스트 할 때, userInfo의 indexPath.row값을 딕셔너리로 보내는데, 이것도 가져와 보겠음.
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary  // 수정된 diary(전달 받은 거)객체를 대입
        self.configureView()  // 수정된 것이 View가 업데이트되게 만듦.
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditroMode = .edit(indexPath, diary)
        // notification옵저빙
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)  // 해당 인스턴스에 추가된 옵저버가 모두 삭제되게...
    }
    
}
