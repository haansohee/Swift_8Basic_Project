//
//  ViewController.swift
//  QuotesGenarator
//
//  Created by 한소희 on 2022/07/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let quotes = [
        Quote(content: "죽음을 두려워하는 나머지 삶을 시작조차 못하는 사람이 많다.", name: "벤다이크"),
        Quote(content: "나는 나 자신을 빼 놓고는 모무 안다.", name: "비용"),
        Quote(content: "편견이란 실효성이 없는 의견이다.", name: "암브로스 빌"),
        Quote(content: "분노는 바보들의 가슴 속에서만 살아간다.", name: "아인슈타인"),
        Quote(content: "몇 번이라도 좋다! 이 끔찍한 생이여... 다시!", name: "니체")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tap(_ sender: Any) {
        let random = Int(arc4random_uniform(5))  // 0~4 사이의 난수를 랜덤하게 만들어줌. 배열의 인덱스에 접근해야 하기 때문에 Int 형으로 변환시켜줌.
        let quote = quotes[random]
        
        quoteLabel.text = quote.content
        nameLabel.text = quote.name
    }
    
}

