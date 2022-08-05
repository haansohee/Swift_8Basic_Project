//
//  ViewController.swift
//  To-do-List
//
//  Created by 한소희 on 2022/08/05.
//

import UIKit

class ViewController: UIViewController {
    // 할 일들을 저장하는 배열
    
    var tasks = [Task](){
        didSet {
            self.saveTasks()
        }
    }
    

    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var doneButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        
        // 등록 버튼을 눌렀을 때 textField에 입력된 값을 가져오도록 구현한 코드
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }   // textFields 프로퍼티는 배열임. textFeild를 alert에 하나밖에 추가하지 않았으니 0번째 배열에 접근.
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            // 할 일을 등록할 때마다 테이블뷰를 갱신하여 추가된 할일이 테이블 뷰에 표시되게 구현하는 코드
            self?.tableView.reloadData()
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        
        // alert에 TextField 추가하는 방법
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "할 일을 입력해 주세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 할 일들이 UserDefaults 저장되는 코드
    func saveTasks() {
        // 할 일들을 딕셔너리 형태로 저장
        let data = self.tasks.map {  // 배열에 있는 요소들을 딕셔너리 형태로 mapping
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")  // UserDefaults에 데이터 저장.
    }
    
    // UserDefaults에 저장된 데이터들을 로드하는 코드.
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else {return}
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
}

// 코드의 가독성을 위해 viewController를 따로 빼서, UITableViewDataSource에 정의된 메서드들만 이 extension 안에 정의되게 UITableViewDataSource을 채택.
extension ViewController: UITableViewDataSource {
    // Type 'ViewController' does not conform to protocol 'UITableViewDataSource' : UITableViewDataSource 프로토콜에 정의된 옵셔널이 붙지 않는 함수들을 구현해 주지 않아서 생기는 에러.
    
    // UITableViewDataSoure를 채택하였을 때 꼭 구현해 주어야 하는 메서드 (1)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 하나의 섹션에 할 일들을 표시할 것이므로 배열의 개수를 반환.
        return self.tasks.count
    }
    
    // UITableViewDataSoure를 채택하였을 때 꼭 구현해 주어야 하는 메서드 (2)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 특정 섹션의 n번째 row를 그리는 데 필요한 셀을 반환하는 메서드.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]  // 할 일들이 저장되어 있는 배열에 indexPath.row 값으로 배열에 저장되어 있는 할 일 요소들을 갖고 옴.
        // cellForRowAt 메서드 파라미터로 전달된 indexPath는 테이블 뷰에서 cell 위치를 나타내는 인덱스. Section과 Row가 0이라면, 가장 위에 보이는 cell의 위치를 의미.
        // indexPath.row 는 0부터 tasks 배열의 개수까지.
        cell.textLabel?.text = task.title
        
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done  // true가 저장되어 있으면 false가 저장되게끔
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
