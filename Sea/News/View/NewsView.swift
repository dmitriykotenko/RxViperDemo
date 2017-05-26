//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol NewsView {
    
    /// Входы.
    func showLoadingState()
    func showConnectionError(errorText: String)
    func showNews(news: News, date: Date)
    
    /// Выходы.
    var viewIsReady: Observable<Void> { get }
    var loadButtonTaps: Observable<Void> { get }
}
