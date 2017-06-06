//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import UIKit


class NewsRouterImpl: NewsRouter {
    
    func openDateModule(currentDate: Date) -> DateModule {        
        let dateModule = DateAssembly().buildModule(date: currentDate)
        
        currentViewController.present(dateModule.viewController, animated: true, completion: nil)
        
        return dateModule
    }
    
    private var currentViewController: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}

