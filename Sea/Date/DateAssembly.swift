//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class DateAssembly {
    
    private var presenter: DatePresenter!
    private var router: DateRouter!
    private var view: DateViewController!
    
    private var module: DateModule!
    private var moduleDisposeBag: DisposeBag!
    
    func buildModule(date: Date) -> DateModule {
        module = DateModule()
        
        moduleDisposeBag = module.disposeBag
        
        presenter = DatePresenter(date: date)
        router = DateRouter()
        view = UIStoryboard(name: "Date", bundle: Bundle.main).instantiateInitialViewController() as! DateViewController
        
        let moduleReference: [Any] = [module, presenter, router]
        view.moduleReference = moduleReference
        
        view.ready
            .subscribe(onSuccess: {
                self.connectEverything()
            })
            .disposed(by: moduleDisposeBag)
        
        module.viewController = view
        
        return module
    }
    
    private func connectEverything() {
        // 1. Bind view to presenter.
        presenter.initialDate.asObservable()
            .bind(to: view.initialDate)
            .disposed(by: moduleDisposeBag)
        
        view.date
            .bind(to: presenter.date)
            .disposed(by: moduleDisposeBag)
        
        view.okButtonTapped
            .bind(to: presenter.okButtonTapped)
            .disposed(by: moduleDisposeBag)
        
        // 2. Bind presenter to router.
        presenter.close.asObservable()
            .bind(to: router.close)
            .disposed(by: moduleDisposeBag)
        
        // 3. Bind presenter to module output.
        presenter.dateSelected.asObservable()
            .bind(to: module.dateSelectedSubject)
            .disposed(by: moduleDisposeBag)
    }
}
