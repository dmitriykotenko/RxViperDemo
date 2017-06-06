//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateView {
    
    // Входы.
    var initialDate: PublishSubject<Date> { get }
    
    // Выходы.
    var ready: Single<Void> { get }
    var date: Observable<Date> { get }
    var okButtonTapped: Observable<Void> { get }
}
