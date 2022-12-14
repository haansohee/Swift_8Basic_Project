//
//  ViewController.swift
//  Weather
//
//  Created by 한소희 on 2022/08/11.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최저: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(messgae: String) {
        let alert = UIAlertController(title: "에러", message: messgae, preferredStyle: .alert)
        alert.addAction(title: "확인", style: .default, handler: nil)
        self.presentationController(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=87a4207f74d20ed1ebfad26f38b7f891") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let data = data, error == nil else { return }
                let decoder = JSONDecoder()
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                
                    }
                } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                    DispatchQueue.main.async {
                        self?.showAlert(messgae: errorMessage.message)
                    }
                }
            }.resume()
        }
}

