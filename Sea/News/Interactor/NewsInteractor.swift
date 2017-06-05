//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


enum LoadingResult {
    case success(news: News, date: Date)
    case error(text: String)
}


protocol NewsInteractor {
    
    // Входы.
    var loadNews: PublishSubject<Date> { get }
    
    // Выходы.
    var newsLoaded: Observable<LoadingResult> { get }
}
