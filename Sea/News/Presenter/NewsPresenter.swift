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
    
    // Выходы.
    private var dateVariable: BehaviorSubject<Date> = BehaviorSubject(value: Date())
    var date: Observable<Date> {
        return dateVariable.asObservable()
    }
    
    private var newsStateVariable: BehaviorSubject<NewsState> = BehaviorSubject(value: .loading)
    var newsState: Observable<NewsState> {
        return newsStateVariable.asObservable()
    }
    
    private var loadNewsVariable: BehaviorSubject<Date> = BehaviorSubject(value: Date())
    var loadNews: Observable<Date> {
        return loadNewsVariable.asObservable()
    }

    private var selectDateSubject: PublishSubject<Date> = PublishSubject()
    var selectDate: Observable<Date> {
        return selectDateSubject.asObservable()
    }

    private var disposeBag = DisposeBag()
    
    init() {
    }
    
    func setupBindings(loadButtonTapped: Observable<Void>,
                       selectDateButtonTapped: Observable<Void>,
                       dateSelected: Observable<Date>,
                       newsLoaded: Observable<LoadingResult>) {
        
        // Перезагружаем новости при нажатии на кнопку «Обновить».
        loadButtonTapped
            .flatMap { [unowned self] in self.dateVariable }
            .bind(to: loadNewsVariable)
            .disposed(by: disposeBag)
        
        dateSelected
            .bind(to: dateVariable)
            .disposed(by: disposeBag)
        
        // Перезагружаем новости каждый раз, когда поменялась дата.
        dateVariable.asObservable()
            .distinctUntilChanged()
            .bind(to: loadNewsVariable)
            .disposed(by: disposeBag)
        
        loadNewsVariable.asObservable()
            .map { _ in return .loading }
            .bind(to: newsStateVariable)
            .disposed(by: disposeBag)
        
        newsLoaded
            .map { [unowned self] in self.parseLoadingResult($0) }
            .bind(to: newsStateVariable)
            .disposed(by: disposeBag)
        
        // Выбор даты.
        selectDateButtonTapped
            .flatMap { [unowned self] in self.dateVariable }
            .bind(to: selectDateSubject)
            .disposed(by: disposeBag)
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
