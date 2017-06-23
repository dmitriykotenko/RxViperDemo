//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateView {

    /// Сильная ссылка на все компоненты модуля. Нужна, чтобы они не пропали из памяти раньше времени.
    var moduleReference: Any? { get set }
    
    // Входы.
    var initialDate: PublishSubject<Date> { get }
    
    // Выходы.
    var ready: Single<Void> { get }
    var date: Observable<Date> { get }
    var okButtonTapped: Observable<Void> { get }
}
