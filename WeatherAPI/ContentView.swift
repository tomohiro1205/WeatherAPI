//
//  ContentView.swift
//  HogeHoge9
//
//  Created by melon on 2020/05/15.
//  Copyright © 2020 melon-group. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   //  天気情報
   @State var resultMessage = ""
   //  気温
   @State var tempMessage = ""
   //  降水確率
   @State var humidityMessage = ""
   //  風速
    @State var windspeedMessage = ""

   //  true: 東京 false: 大阪
   @State var bLocationFlag = false

   //  キー情報
   let KeyCode = "41e5b26a2ffabe9e063aed919f9e22f0"
   //  天気情報取得用クラス
   var obj = OpenWetherMap()

   //  取得した天気情報を処理するよ
   func GetData(data: Temperatures){
       self.resultMessage = ""
       //  温度をセット(摂氏)
       self.tempMessage = "\(data.main.temp)°C"
       //  湿度をセット
       self.humidityMessage = "\(data.main.humidity)%"
       //  風速をセット
       self.windspeedMessage = "\(data.wind.speed)m/s"

       //  天気情報のメッセージをセット
       data.weather.forEach{
           item in
           if( self.resultMessage.count == 0 )
           {
               self.resultMessage = "\n" +  item.weatherDescription + "\n"
           }
           else{
               self.resultMessage = self.resultMessage +  item.weatherDescription + "\n"
           }
       }
   }
   var body: some View {
       VStack{
           //  天気取得用ボタンだよ
           Button(action:{
               //  APIの仕様(https://openweathermap.org/current)
               var invokeURL = ""
               //  東京の場合
               if(self.bLocationFlag){
                   invokeURL = "https://api.openweathermap.org/data/2.5/weather?q=Tokyo,jp&appid=\(self.KeyCode)&lang=ja&units=metric"
               }
                   //  大阪の場合
               else{
                   invokeURL = "https://api.openweathermap.org/data/2.5/weather?q=Osaka,jp&appid=\(self.KeyCode)&lang=ja&units=metric"
               }
               //  天気情報を取得(APIコール)
               self.obj.getWather(invoke_url: invokeURL, action: self.GetData)
           })
           {
               HStack{
                   //  天気情報を取得するロケーション設定用トグル
                   //  シンプルに見せる為にトグルにしてます。
                   //  今回はAPIをコールするところがメインです。
                   Toggle(isOn: $bLocationFlag) {
                   Text(self.bLocationFlag ? "東京" : "大阪")
                   }
               .padding()
                   Text("今日の天気は?")
                   .padding()
                   .border(Color.black)
               }
           }
           HStack{
               Text("天気 ")
                   .padding()
               Text("\(resultMessage)")
               .padding()
           }
           HStack{
               Text("気温 ")
                   .padding()
               Text("\(tempMessage)")
               .padding()
           }
           HStack{
               Text("湿度 ")
                   .padding()
               Text("\(humidityMessage)")
               .padding()
           }
           HStack{
               Text("風速 ")
                   .padding()
               Text("\(windspeedMessage)")
               .padding()

           }
       }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       ContentView()
   }
}

