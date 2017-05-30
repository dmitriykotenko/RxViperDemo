//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import UIKit


class NewsRouterImpl: NewsRouter {
    
    func openDateModule(currentDate: Date) -> DateModule {        
        guard let dateViewController = UIStoryboard(name: "Date", bundle: Bundle.main).instantiateInitialViewController() as? DateViewController else {
            fatalError("Can not instantiate DateViewController.")
        }

        let datePresenter = DatePresenter()
        datePresenter.view = dateViewController
        datePresenter.configureModule(date: currentDate)
        
        currentViewController.present(dateViewController, animated: true, completion: nil)
        
        return datePresenter
    }
    
    private var currentViewController: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}

