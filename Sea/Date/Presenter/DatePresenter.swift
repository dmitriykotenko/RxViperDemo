//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class DatePresenter: DateModule {

    var view: DateView!
    
    var currentDate: Variable<Date> = Variable(Date())
    
    private var disposeBag = DisposeBag()
    
    func configureModule(date: Date) {
        self.currentDate.value = date
        
        view.viewIsReady.subscribe(onNext: { [weak self] in
            self?.connectEverything()
        })
        .disposed(by: disposeBag)
    }
    
    func connectEverything() {
        currentDate.asObservable().take(1)
            .bind(to: view.initialDate)
            .disposed(by: disposeBag)
        
        view.date
            .bind(to: currentDate)
            .disposed(by: disposeBag)
        
        view.okButtonTaps
            .map { return self.currentDate.value }
            .bind(to: dateSelectedSubject)
            .disposed(by: disposeBag)
    }
    
    var dateSelectedSubject = PublishSubject<Date>()
    var dateSelected: Observable<Date> {
        return dateSelectedSubject.asObservable()
    }
}
