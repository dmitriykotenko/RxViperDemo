//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


enum LoadingResult {
    case success(news: News, date: Date)
    case error(text: String)
}


class NewsInteractor {
    
    var newsLoadedSubject: PublishSubject<LoadingResult> = PublishSubject()
    
    var newsLoaded: Observable<LoadingResult> {
        return newsLoadedSubject.asObservable()
    }

    var api: NewsApi = NewsApiImpl()
    var loadNews: PublishSubject<Date> = PublishSubject()
    
    private var disposeBag = DisposeBag()

    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        loadNews
            .subscribe(onNext: loadNews)
            .disposed(by: disposeBag)
    }
    
    func loadNews(date: Date) {
        api.news(date: date) { [weak self] (news, error) in
            if let news = news {
                self?.newsLoadedSubject.onNext(.success(news: news, date: date))
            } else {
                let errorText = error ?? "Неизвестная ошибка"
                self?.newsLoadedSubject.onNext(.error(text: errorText))
            }
        }
    }
}
