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
    private var dateVariable: Variable<Date> = Variable(Date())
    private var newsStateVariable: Variable<NewsState> = Variable(.loading)
    var viewModel: Observable<NewsViewState> {
        return Observable.combineLatest(
            dateVariable.asObservable(),
            newsStateVariable.asObservable()
        ) { (date, news) in
            NewsViewState(date: date, newsState: news)
        }
    }
    
    private var loadNewsVariable: Variable<Date> = Variable(Date())
    var loadNews: Observable<Date> {
        return loadNewsVariable.asObservable()
    }

    private var selectDateSubject: PublishSubject<Date> = PublishSubject()
    var selectDate: Observable<Date> {
        return selectDateSubject.asObservable()
    }
    
    // Входы.
    var loadButtonTapped: PublishSubject<Void> = PublishSubject()
    var selectDateButtonTapped: PublishSubject<Void> = PublishSubject()
    var dateSelected: PublishSubject<Date> = PublishSubject()
    var newsLoaded: PublishSubject<LoadingResult> = PublishSubject()
    
    private var disposeBag = DisposeBag()
    
    init() {
        // Перезагружаем новости при нажатии на кнопку «Обновить».
        loadButtonTapped
            .map { [unowned self] in self.dateVariable.value }
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
            .map { return self.dateVariable.value }
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
