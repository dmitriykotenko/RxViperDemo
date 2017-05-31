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
    var state: Variable<NewsViewState> { get }
    
    /// Выходы.
    var viewIsReady: Single<Void> { get }
    var loadButtonTaps: Observable<Void> { get }
    var selectDateButtonTaps: Observable<Void> { get }
}
