//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsInteractorImpl: NewsInteractor {
    
    var loadingResultSubject: PublishSubject<LoadingResult> = PublishSubject()
    
    var loadingResult: Observable<LoadingResult> {
        return loadingResultSubject.asObservable()
    }

    var api: NewsApi = NewsApiImpl()
    var loadingRequest: PublishSubject<Date> = PublishSubject()
    
    private var disposeBag = DisposeBag()

    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        loadingRequest
            .subscribe(onNext: loadNews)
            .disposed(by: disposeBag)
    }
    
    func loadNews(date: Date) {
        api.news(date: date) { [weak self] (news, error) in
            if let news = news {
                self?.loadingResultSubject.onNext(.success(news: news, date: date))
            } else {
                let errorText = error ?? "Неизвестная ошибка"
                self?.loadingResultSubject.onNext(.error(text: errorText))
            }
        }
    }
}
