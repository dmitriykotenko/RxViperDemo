//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


enum NewsViewState {
    case loading
    case success(news: News, date: Date)
    case error(errorText: String)
}


protocol NewsView {
    
    /// Входы.
    func setState(_ state: NewsViewState)
    
    /// Выходы.
    var viewIsReady: Observable<Void> { get }
    var loadButtonTaps: Observable<Void> { get }
}
