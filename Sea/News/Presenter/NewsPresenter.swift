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
            })
            .disposed(by: disposeBag)
    }
    
    func connectEverything() {
        interactor.loadingResult
            .subscribe(onNext: { loadingResult in
                switch loadingResult {
                case let .success(news, date):
                    self.view?.setState(.success(news: news, date: date))
                case let .error(errorText):
                    self.view?.setState(.error(errorText: errorText))
                }
            })
            .disposed(by: disposeBag)

        view?.loadButtonTaps
            .subscribe(onNext: {
                self.view?.setState(.loading)
                self.interactor.loadNews(date: Date())
            })
            .disposed(by: disposeBag)
    }
}
