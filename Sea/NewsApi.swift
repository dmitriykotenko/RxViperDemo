//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import Foundation


typealias News = [String]


protocol NewsApi {
    
    func news(date: Date, onComplete: @escaping (News?, String?) -> Void)
}


class NewsApiImpl: NewsApi {

    func news(date: Date, onComplete: @escaping (News?, String?) -> Void) {
        let news1 = [
            "Бюджетные авиалинии уберут кресла для пассажиров.",
            "Анастасия Загороднюк растоптана фанатами.",
            "Первый пешеходный переход для кур создан в Перу.",
            ]
        
        let news2 = [
            "Британский парламентарий получил право носить меч.",
            "Франция планирует запретить населению работать.",
            "Руководство Китая сменило свой имидж.",
            ]
        
        let news3 = [
            "Демократы решили, что все люди «равны».",
            "Водитель госпитализирован после столкновения с зомби.",
            "Итальянского водопроводчика наказали за убийство черепах.",
            ]
        
        let news = [news1, news2, news3]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let index = Int(arc4random() % 4)
            let isSuccess = index < 3
            
            if isSuccess {
                onComplete(news[index], nil)
            } else {
                onComplete(nil, "Сервер не ответил")
            }
        }
    }
}
