//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol NewsView {
    
    /// Входы.
    var date: Variable<Date> { get }
    var newsState: Variable<NewsState> { get }
    
    /// Выходы.
    var viewIsReady: Single<Void> { get }
    var loadButtonTaps: Observable<Void> { get }
    var selectDateButtonTaps: Observable<Void> { get }
}
