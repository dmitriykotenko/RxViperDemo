//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsModule: ViewControllerModule {
    
    var dateSubject: PublishSubject<Date> = PublishSubject()
    
    var date: Observable<Date> {
        return dateSubject.asObservable()
    }
    
    let disposeBag = DisposeBag()
}
