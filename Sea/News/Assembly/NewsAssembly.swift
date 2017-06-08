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
    
    func buildModule() -> NewsModule {
        let module = NewsModule()
        
        moduleDisposeBag = module.disposeBag
        
        interactor = NewsInteractorImpl()
        presenter = NewsPresenter()
        router = NewsRouterImpl()
        view = UIStoryboard(name: "News", bundle: Bundle.main).instantiateInitialViewController() as! NewsViewController
        
        let moduleReference: [Any] = [module, interactor, presenter, router]
        view.moduleReference = moduleReference
        
        view.ready
            .subscribe(onSuccess: {
                self.connectEverything()
            })
            .disposed(by: moduleDisposeBag)

        module.viewController = view as! UIViewController
        presenter.date.asObservable()
            .bind(to: module.dateSubject)
            .disposed(by: moduleDisposeBag)
        
        return module
    }
    
    func connectEverything() {
        // 1. Bind interactor to presenter.
        presenter.loadNews.asObservable()
            .bind(to: interactor.loadNews)
            .disposed(by: moduleDisposeBag)
        
        interactor.newsLoaded
            .bind(to: presenter.newsLoaded)
            .disposed(by: moduleDisposeBag)
        
        // 2. Bind presenter to view.
        view.loadButtonTapped
            .bind(to: presenter.loadButtonTapped)
            .disposed(by: moduleDisposeBag)
        
        view.selectDateButtonTapped
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
