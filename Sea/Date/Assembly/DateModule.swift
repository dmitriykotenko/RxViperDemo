//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class DateModule: ViewControllerModule {
    
    var dateSelectedSubject: PublishSubject<Date> = PublishSubject()
    var dateSelected: Single<Date> {
        return dateSelectedSubject.asSingle()
    }
    
    let disposeBag = DisposeBag()
}
