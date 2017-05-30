//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateView {
    
    // Входы.
    var initialDate: Variable<String> { get }
    
    // Выходы.
    var viewIsReady: PublishSubject<Void> { get }
    var topic: Observable<String> { get }
    var okButtonTaps: Observable<Void> { get }
}
