//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class DatePresenter: DateModule {

    var view: DateView!
    var router: DateRouter! = DateRouterImpl()
    
    var currentDate: Variable<Date> = Variable(Date())
    
    private var disposeBag = DisposeBag()
    
    func configureModule(date: Date) {
        self.currentDate.value = date
        
        view.viewIsReady.subscribe(onSuccess: { [weak self] in
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
            .subscribe( onNext: { _ in
                self.done()
            })
            .disposed(by: disposeBag)
    }
    
    private func done() {
        dateSelectedSubject.onNext(currentDate.value)
        dateSelectedSubject.onCompleted()
        router.close()
    }
    
    var dateSelectedSubject = PublishSubject<Date>()
    var dateSelected: Single<Date> {
        return dateSelectedSubject.asSingle()
    }
}
