//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol NewsView {
    
    /// Входы.
    var date: Variable<Date> { get }
    var newsState: Variable<NewsState> { get }
    
    /// Выходы.
    var ready: Single<Void> { get }
    var loadButtonTapped: Observable<Void> { get }
    var selectDateButtonTapped: Observable<Void> { get }
}
