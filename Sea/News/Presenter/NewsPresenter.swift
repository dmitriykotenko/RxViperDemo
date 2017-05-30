//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsPresenter {
    
    private var disposeBag = DisposeBag()
    
    var interactor: NewsInteractor = NewsInteractorImpl()

    var view: NewsView? {
        didSet {
            configureModule()
        }
    }
    
    func configureModule() {
        view?.viewIsReady
            .subscribe(onNext: { [weak self] in
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

        view!.loadButtonTaps
            .map { return .loading }
            .bind(to: view!.state)
            .disposed(by: disposeBag)

        interactor.loadingResult
            .map ( parseLoadingResult )
            .bind(to: view!.state)
            .disposed(by: disposeBag)
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
