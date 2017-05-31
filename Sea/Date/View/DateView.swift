//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateView {
    
    // Входы.
    func setupInitialState(date: Date)
    
    // Выходы.
    var viewIsReady: Single<Void> { get }
    var date: Observable<Date> { get }
    var okButtonTaps: Observable<Void> { get }
}
