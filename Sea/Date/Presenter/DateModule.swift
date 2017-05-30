//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol DateModule {

    func configureModule(topic: String)
    
    var topicSelected: Observable<String> { get }
}
