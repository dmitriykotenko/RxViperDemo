//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateModule {

    func configureModule(date: Date)
    
    var dateSelected: Single<Date> { get }
}
