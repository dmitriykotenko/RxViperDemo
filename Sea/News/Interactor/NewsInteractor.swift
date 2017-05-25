//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


enum LoadingResult {
    
    case success(news: News, date: Date)
    
    case error(text: String)
}


protocol NewsInteractor {
    
    // Inputs.
    func loadNews(date: Date)
    
    // Outputs.
    var loadingResult: Observable<LoadingResult> { get }
}
