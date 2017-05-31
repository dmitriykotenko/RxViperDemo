//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsPresenter {
    
    private var disposeBag = DisposeBag()
    private var dateModuleDisposeBag = DisposeBag()
    
    var interactor: NewsInteractor = NewsInteractorImpl()
    var router: NewsRouter = NewsRouterImpl()

    private var currentDate = Date()
    
    var view: NewsView? {
        didSet {
            configureModule()
        }
    }
    
    func configureModule() {
        view?.viewIsReady
            .subscribe(onSuccess: { [weak self] in
                self?.connectEverything()
                self?.interactor.loadingRequest.onNext(Date())
            })
            .disposed(by: disposeBag)
    }
    
    func connectEverything() {
        view?.loadButtonTaps
            .map { return Date() }
            .bind(to: interactor.loadingRequest)
            .disposed(by: disposeBag)
        
        view?.selectDateButtonTaps
            .map { self.currentDate }
            .flatMap ( openDateModule )
            .bind(to: interactor.loadingRequest)
            .disposed(by: disposeBag)

        interactor.loadingRequest
            .map { _ in return .loading }
            .bind(to: view!.state)
            .disposed(by: disposeBag)
        
        interactor.loadingResult
            .map ( parseLoadingResult )
            .bind(to: view!.state)
            .disposed(by: disposeBag)
    }
    
    private func openDateModule(_ date: Date) -> Single<Date> {
        let dateModule = router.openDateModule(currentDate: date)
        
        return dateModule.dateSelected
    }
    
    private func parseLoadingResult(_ loadingResult: LoadingResult) -> NewsViewState {
        switch loadingResult {
        case let .success(news, date):
            return .success(news: news, date: date)
        case let .error(errorText):
            return .error(errorText: errorText)
        }
    }
}
