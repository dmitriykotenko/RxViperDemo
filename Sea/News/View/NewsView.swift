//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol NewsView {
    
    /// Сильная ссылка на все компоненты модуля. Нужна, чтобы они не пропали из памяти раньше времени.
    var moduleReference: Any? { get set }
    
    /// Входы.
    var date: Variable<Date> { get }
    var newsState: Variable<NewsState> { get }
    
    /// Выходы.
    var ready: Single<Void> { get }
    var loadButtonTapped: Observable<Void> { get }
    var selectDateButtonTapped: Observable<Void> { get }
}
