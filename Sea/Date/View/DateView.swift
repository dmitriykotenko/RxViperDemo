//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateView {
    
    // Входы.
    func setupInitialState(date: Date)
    
    // Выходы.
    var ready: Single<Void> { get }
    var date: Observable<Date> { get }
    var okButtonTapped: Observable<Void> { get }
}
