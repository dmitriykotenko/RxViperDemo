//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class TopicPresenter: TopicModule {

    var view: TopicView!
    
    var currentTopic: Variable<String> = Variable("")
    
    private var disposeBag = DisposeBag()
    
    func configureModule(topic: String) {
        self.currentTopic.value = topic
        
        view.viewIsReady.subscribe(onNext: { [weak self] in
            self?.connectEverything()
        })
        .disposed(by: disposeBag)
    }
    
    func connectEverything() {
        currentTopic.asObservable().take(1)
            .bind(to: view.initialTopic)
            .disposed(by: disposeBag)
        
        view.topic
            .bind(to: currentTopic)
            .disposed(by: disposeBag)
        
        view.okButtonTaps
            .map { return self.currentTopic.value }
            .bind(to: topicSelectedInternal)
            .disposed(by: disposeBag)
    }
    
    var topicSelectedInternal = PublishSubject<String>()
    var topicSelected: Observable<String> {
        return topicSelectedInternal
    }
}
