//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsAssembly {
    
    private var interactor: NewsInteractor!
    private var presenter: NewsPresenter!
    private var router: NewsRouter!
    private var view: NewsViewController!
    
    private var moduleDisposeBag = DisposeBag()
    
    func buildModule() -> NewsModule {
        let module = NewsModule()
        
        moduleDisposeBag = module.disposeBag
        
        interactor = NewsInteractor()
        presenter = NewsPresenter()
        router = NewsRouter()
        view = UIStoryboard(name: "News", bundle: Bundle.main).instantiateInitialViewController() as! NewsViewController
        
//        let moduleReference: [Any] = [module, interactor, presenter, router]
//        view.moduleReference = moduleReference
        view.moduleAssembly = self
        
        view.ready
            .subscribe(onSuccess: { [weak self] in
                self?.connectEverything()
            })
            .disposed(by: moduleDisposeBag)

        module.viewController = view
        presenter.date
            .bind(to: module.dateSubject)
            .disposed(by: moduleDisposeBag)
        
        return module
    }
    
    func connectEverything() {
        // 1. Bind interactor to presenter.
        
        view.setupBindings(date: presenter.date, newsState: presenter.newsState)
        
        router.setupBindings(dateSelectedObservable: presenter.selectDate)
        
        interactor.setupBindings(presenter.loadNews)
        
        presenter.setupBindings(loadButtonTapped: view.loadButtonTapped,
                                selectDateButtonTapped: view.selectDateButtonTapped,
                                dateSelected: router.selectedDate,
                                newsLoaded: interactor.newsLoaded)
        
        
    }
}
