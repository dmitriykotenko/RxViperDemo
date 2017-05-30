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
        let news = ["Буратино утонул", "Колобок повесился", "В кузне сидел травечик, огусем как совречик..."]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let isSuccess = arc4random() % 3 > 0
            
            if isSuccess {
                onComplete(news, nil)
            } else {
                onComplete(nil, "Сервер не ответил")
            }
        }
    }
}
