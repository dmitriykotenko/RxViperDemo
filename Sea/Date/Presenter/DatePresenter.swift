//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class DatePresenter: DateModule {

    var view: DateView!
    
    var currentDate: Variable<String> = Variable("")
    
    private var disposeBag = DisposeBag()
    
    func configureModule(topic: String) {
        self.currentDate.value = topic
        
        view.viewIsReady.subscribe(onNext: { [weak self] in
            self?.connectEverything()
        })
        .disposed(by: disposeBag)
    }
    
    func connectEverything() {
        currentDate.asObservable().take(1)
            .bind(to: view.initialDate)
            .disposed(by: disposeBag)
        
        view.topic
            .bind(to: currentDate)
            .disposed(by: disposeBag)
        
        view.okButtonTaps
            .map { return self.currentDate.value }
            .bind(to: topicSelectedInternal)
            .disposed(by: disposeBag)
    }
    
    var topicSelectedInternal = PublishSubject<String>()
    var topicSelected: Observable<String> {
        return topicSelectedInternal
    }
}
