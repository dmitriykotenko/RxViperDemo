//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateView {
    
    // Входы.
    var initialDate: Variable<Date> { get }
    
    // Выходы.
    var viewIsReady: PublishSubject<Void> { get }
    var date: Observable<Date> { get }
    var okButtonTaps: Observable<Void> { get }
}
