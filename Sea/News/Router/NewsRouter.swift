//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import UIKit
import RxSwift


class NewsRouter {
    
    var selectedDate: Observable<Date>!
    
    func setupBindings(dateSelectedObservable: Observable<Date>) {
        // Выбор даты.
        selectedDate = dateSelectedObservable
            .flatMap { [unowned self] in self.openDateModule(currentDate: $0) }
    }
    
    func openDateModule(currentDate: Date) -> Observable<Date> {
        let dateModule = DateAssembly().buildModule(date: currentDate)
        
        currentViewController.present(dateModule.viewController, animated: true, completion: nil)
        
        return dateModule.dateSelected.asObservable()
    }
    
    private var currentViewController: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}

