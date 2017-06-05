//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsAssembly {
    
    private var interactor: NewsInteractor!
    private var presenter: NewsPresenter!
    private var router: NewsRouter!
    private var view: NewsView!
    
    private var moduleDisposeBag = DisposeBag()
    
    private var strongSelf: NewsAssembly!
    
    func buildModule() -> UIViewController {
        // Хак, чтобы moduleDisposeBag не пропал мгновенно из памяти.
        strongSelf = self
        
        moduleDisposeBag = DisposeBag()
        
        interactor = NewsInteractorImpl()
        presenter = NewsPresenter()
        router = NewsRouterImpl()
        view = UIStoryboard(name: "News", bundle: Bundle.main).instantiateInitialViewController() as! NewsViewController
        
        view.viewIsReady
            .subscribe(onSuccess: { [weak self] in
                self?.connectEverything()
            })
            .disposed(by: moduleDisposeBag)
        
        return view as! NewsViewController
    }
    
    func connectEverything() {
        // 1. Bind interactor to presenter.
        presenter.loadNews.asObservable()
            .bind(to: interactor.loadingRequest)
            .disposed(by: moduleDisposeBag)
        
        interactor.loadingResult
            .bind(to: presenter.newsLoaded)
            .disposed(by: moduleDisposeBag)
        
        // 2. Bind presenter to view.
        view.loadButtonTaps
            .bind(to: presenter.loadButtonTapped)
            .disposed(by: moduleDisposeBag)
        
        view.selectDateButtonTaps
            .bind(to: presenter.selectDateButtonTapped)
            .disposed(by: moduleDisposeBag)
        
        presenter.date.asObservable()
            .bind(to: view.date)
            .disposed(by: moduleDisposeBag)
        
        presenter.newsState.asObservable()
            .bind(to: view.newsState)
            .disposed(by: moduleDisposeBag)
        
        // 3. Bind presenter to router.
        presenter.selectDate
            .flatMap( runDateModule )
            .bind(to: presenter.date)
            .disposed(by: moduleDisposeBag)
    }
    
    private func runDateModule() -> Single<Date> {
        let dateModule = router.openDateModule(currentDate: presenter.date.value)
        
        return dateModule.dateSelected
    }
}
