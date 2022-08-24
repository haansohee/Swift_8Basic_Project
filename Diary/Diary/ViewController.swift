//
//  ViewController.swift
//  Diary
//
//  Created by 한소희 on 2022/08/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController
        {
            writeDiaryViewController.delegate = self
        }
    }
}

//extension ViewController: UICollectionViewDataSource {
//    // 콜렉션뷰에서 데이터소스는 콜렉션뷰로 보여주는 컨텐츠를 관리
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.diaryList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Diary", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
//
//        let diary = self.diaryList[indexPath.row]
//        cell.titleLabel.text = diary.title
////        cell.dateLabel.text=
//    }
    
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
    }
}
