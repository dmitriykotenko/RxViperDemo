//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import UIKit


protocol ViperModule {}


/// VIPER module whose view layer is UIViewController.
///
/// This view controller should retain other module's members and module's dispose bag.
class ViewControllerModule: ViperModule {

    var viewController: UIViewController!
}
