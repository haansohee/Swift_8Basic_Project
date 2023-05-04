//
//  ViewController.swift
//  Corona19_Bye
//
//  Created by 한소희 on 2023/05/04.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicatorView.startAnimating()
        
        self.fetchCovidOverview(completionHandler: {
            [weak self] result in
            guard let self = self else {return}
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.mkaeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverviewList: covidOverviewList)
                
            case let .failure(error):
                debugPrint("Error! \(error)")
            }
            
        })
    }
    func mkaeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju
        ]
    }
    
    func configureChartView(covidOverviewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        
        let entries = covidOverviewList.compactMap {
            [weak self] overview -> PieChartDataEntry? in
            guard let self = self else {return nil}
            return PieChartDataEntry(value: self.removeFormatString(string: overview.newCase),
                                     label: overview.countryName,
                                     data: overview)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        
        dataSet.sliceSpace = 1
        dataSet.xValuePosition = .outsideSlice
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.liberty() +
        ChartColorTemplates.pastel() +
        ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase) 명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase) 명"
    }
    
    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    ) { // api를 요청하고 서버에서 json 데이터를 응답받거나, 요청 실패했을 때 해당 클로저를 호출하여 해당 클로저를 정의하는 곳에 응답받은 데이터를 전달
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "E8wWxGmVuLSQPokC7tsjIhXefpHJaqb96"
        ]
        
        // api 호출
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
            switch response.result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CityCovidOverview.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
                
            case let .failure(error):
                completionHandler(.failure(error))
            }
        })
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailTableViewController") as? CovidDetailTableViewController else {return}
        
        guard let covidOverView = entry.data as? CovidOverview else {return}
        covidDetailViewController.covidOverview = covidOverView
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}

