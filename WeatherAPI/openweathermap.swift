//
//  openweathermap.swift
//  HogeHoge9
//
//  Created by melon on 2020/05/16.
//  Copyright © 2020 melon-group. All rights reserved.
//

import SwiftUI

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let temperatures = try? newJSONDecoder().decode(Temperatures.self, from: jsonData)

import Foundation

// MARK: - Temperatures
struct Temperatures: Codable {
   let coord: Coord
   let weather: [Weather]
   let base: String
   let main: Main
   let visibility: Int
   let wind: Wind
   let clouds: Clouds
   let dt: Int
   let sys: Sys
   let timezone, id: Int
   let name: String
   let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
   let all: Int
}

// MARK: - Coord
struct Coord: Codable {
   let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
   let temp, feelsLike, tempMin, tempMax: Double
   let pressure, humidity: Int

   enum CodingKeys: String, CodingKey {
       case temp
       case feelsLike = "feels_like"
       case tempMin = "temp_min"
       case tempMax = "temp_max"
       case pressure, humidity
   }
}

// MARK: - Sys
struct Sys: Codable {
   let type, id: Int
   let country: String
   let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
   let id: Int
   let main, weatherDescription, icon: String

   enum CodingKeys: String, CodingKey {
       case id, main
       case weatherDescription = "description"
       case icon
   }
}

// MARK: - Wind
struct Wind: Codable {
   let speed: Double
   let deg: Int
}

//  結果を戻す関数型定義
typealias RecvFunc = ((_ item:Temperatures)->Void)?
// 天気予報を取得するクラス
class OpenWetherMap{
   //  関数ポインタ
   var _action : ((_ item:Temperatures)->Void)?

   //  結果受け取り用関数ポインタの設定
   func SetAction(action: ((_ item:Temperatures)->Void)?) {
       self._action = action
   }
   //  天気予報を取得(APIコール)
   func getWather(invoke_url: String, action: RecvFunc) -> Void{
       //  関数ポインタをセットします
       self.SetAction(action: action)
       guard let url = URL(string: invoke_url) else {
           print("URLが変じゃね(´д｀)")
           return
       }
       let request = URLRequest(url: url)
       //  非同期通信を実行
       URLSession.shared.dataTask(with: request) {
           data, response, error in
           //  受信が完了したらOK
           if let data = data {
               //  結果のJSONをデコードします!
               if let decodedResponse = try? JSONDecoder().decode(Temperatures.self, from: data) {
                   DispatchQueue.main.async {
                       //  セットした関数を呼び出して結果を返しますわ(*´ｪ`*)
                       self._action!(decodedResponse)
                   }
               }
           }
       }
       //  これめちゃ重要。
       //  これがなければタスクは実行開始されないよ!
       .resume()
   }
}

