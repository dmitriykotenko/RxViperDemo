//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift
import UIKit


class DateRouterImpl: DateRouter {
    
    var close: PublishSubject<Void> = PublishSubject()
    private var disposeBag = DisposeBag()

    init() {
        close
            .subscribe(onNext: { [weak self] in
                self?.closeModule()
            })
            .disposed(by: disposeBag)
    }
    
    func closeModule() {
        currentViewController.dismiss(animated: true, completion: nil)
    }
    
    private var currentViewController: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}
