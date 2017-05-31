//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import UIKit


class DateRouterImpl: DateRouter {
    
    func close() {
        currentViewController.dismiss(animated: true, completion: nil)
    }
    
    private var currentViewController: UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}
