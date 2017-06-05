//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


enum NewsState {
    case loading
    case success(news: News, date: Date)
    case error(errorText: String)
}


class NewsPresenter {
    
    var router: NewsRouter! = NewsRouterImpl()
    
    // Выходы.
    var date: Variable<Date> = Variable(Date())
    var newsState: Variable<NewsState> = Variable(.loading)
    var loadNews: Variable<Date> = Variable(Date())
    
    // Входы.
    var loadButtonTapped: PublishSubject<Void> = PublishSubject()
    var selectDateButtonTapped: PublishSubject<Void> = PublishSubject()
    var newsLoaded: PublishSubject<LoadingResult> = PublishSubject()
    
    private var disposeBag = DisposeBag()
    
    init() {
        // Перезагружаем новости при нажатии на кнопку «Обновить».
        loadButtonTapped
            .map { [unowned self] in self.date.value }
            .bind(to: loadNews)
            .disposed(by: disposeBag)
        
        // Перезагружаем новости каждый раз, когда поменялась дата.
        date.asObservable()
            .distinctUntilChanged()
            .bind(to: loadNews)
            .disposed(by: disposeBag)

        loadNews.asObservable()
            .map { _ in return .loading }
            .bind(to: newsState)
            .disposed(by: disposeBag)
        
        newsLoaded
            .map { [unowned self] in self.parseLoadingResult($0) }
            .bind(to: newsState)
            .disposed(by: disposeBag)

        // Выбор даты.
        selectDateButtonTapped
            .flatMap { [unowned self] in
                return self.openDateModule()
            }
            .bind(to: date)
            .disposed(by: disposeBag)
    }
    
    private func openDateModule() -> Single<Date> {
        let dateModule = router.openDateModule(currentDate: date.value)
        
        return dateModule.dateSelected
    }
    
    private func parseLoadingResult(_ loadingResult: LoadingResult) -> NewsState {
        switch loadingResult {
        case let .success(news, date):
            return .success(news: news, date: date)
        case let .error(errorText):
            return .error(errorText: errorText)
        }
    }
}
