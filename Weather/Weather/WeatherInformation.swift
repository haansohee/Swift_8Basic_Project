//
//  WeatherInformation.swift
//  Weather
//
//  Created by 한소희 on 2022/08/11.
//

import Foundation

struct WeatherInformation: Codable {  // Codable 프로토콜은 자신을 변환하거나 외부 표현으로 변환할 수 타입을 의미. 외부 표현이란 JSON과 같은 타입을 의미함. json 인코딩, 디코딩 다 가능. 한마디로, 웨더인포메이션 객체를 json형태로, json 형태를 웨더인포메이션 객체로 만들 수 있는 것.
    
    let weather: [Weather]
    let temp: Temp
    let name: String  // 도시 이름
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
