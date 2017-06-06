//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateRouter {
    
    /// Закрыть модуль.
    var close: PublishSubject<Void> { get }
}
