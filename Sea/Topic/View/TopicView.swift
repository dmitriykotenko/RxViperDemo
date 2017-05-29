//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


protocol TopicView {

    var topic: Observable<String> { get }
    var selectButtonTaps: Observable<Void> { get }
}
