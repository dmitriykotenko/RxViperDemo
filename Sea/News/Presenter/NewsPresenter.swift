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
    
    var interactor: NewsInteractor = NewsInteractorImpl()
    var router: NewsRouter = NewsRouterImpl()
    var view: NewsView!
    
    private var date: Variable<Date> = Variable(Date())
    private var newsState: Variable<NewsState> = Variable(.loading)
    
    private var disposeBag = DisposeBag()
    
    func configureModule() {
        view.viewIsReady
            .subscribe(onSuccess: { [weak self] in
                self?.connectEverything()
            })
            .disposed(by: disposeBag)
    }
    
    func connectEverything() {
        date.asObservable()
            .bind(to: view!.date)
            .disposed(by: disposeBag)
        
        newsState.asObservable()
            .bind(to: view!.newsState)
            .disposed(by: disposeBag)
        
        view.loadButtonTaps
            .map { [unowned self] in self.date.value }
            .bind(to: interactor.loadingRequest)
            .disposed(by: disposeBag)

        interactor.loadingRequest
            .map { _ in return .loading }
            .bind(to: newsState)
            .disposed(by: disposeBag)
        
        interactor.loadingResult
            .map ( parseLoadingResult )
            .bind(to: newsState)
            .disposed(by: disposeBag)

        // Выбор даты.
        view.selectDateButtonTaps
            .flatMap ( openDateModule )
            .bind(to: date)
            .disposed(by: disposeBag)
        
        // Перезагружаем новости каждый раз, когда поменялась дата.
        date.asObservable()
            .distinctUntilChanged()
            .bind(to: interactor.loadingRequest)
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
