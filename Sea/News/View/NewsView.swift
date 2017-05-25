//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol NewsView {
    
    var viewIsReady: Observable<Void> { get }
    
    func showLoadingState()
    
    func showConnectionError(errorText: String)
    
    func showNews(news: News, date: Date)
    
    var loadButtonTaps: Observable<Void> { get }
}
