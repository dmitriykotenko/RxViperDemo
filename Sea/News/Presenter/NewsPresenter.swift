//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsPresenter {
    
    private var disposeBag = DisposeBag()
    
    var interactor: NewsInteractor = NewsInteractorImpl()

    var view: NewsView? {
        didSet {
            view?.viewIsReady
                .subscribe(onNext: { [weak self] in
                    self?.configureModule()
                })
                .disposed(by: disposeBag)
        }
    }
    
    func configureModule() {
        view?.loadButtonTaps
            .subscribe(onNext: {
                self.view?.showLoadingState()
                self.interactor.loadNews(date: Date())
            })
            .disposed(by: disposeBag)
        
        interactor.loadingResult
            .subscribe(onNext: { loadingResult in
                switch loadingResult {
                case let .success(news, date):
                    self.view?.showNews(news: news, date: date)
                case let .error(errorText):
                    self.view?.showConnectionError(errorText: errorText)
                }
            })
            .disposed(by: disposeBag)
    }
}
