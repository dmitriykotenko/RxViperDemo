//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class DatePresenter {
    
    // Входы.
    var initialDate: Variable<Date> = Variable(Date())
    var date: Variable<Date> = Variable(Date())
    var okButtonTapped: PublishSubject<Void> = PublishSubject()
    
    // Выходы.
    private var dateSelectedSubject = PublishSubject<Date>()
    var dateSelected: Single<Date> {
        return dateSelectedSubject.asSingle()
    }
    
    private var closeSubject = PublishSubject<Void>()
    var close: Single<Void> {
        return closeSubject.asSingle()
    }
    
    private var disposeBag = DisposeBag()
    
    init(date: Date) {
        self.initialDate.value = date
        
        okButtonTapped
            .subscribe( onNext: { _ in
                self.done()
            })
            .disposed(by: disposeBag)
    }
    
    private func done() {
        dateSelectedSubject.onNext(date.value)
        dateSelectedSubject.onCompleted()
        
        closeSubject.onNext()
        closeSubject.onCompleted()
    }
}
