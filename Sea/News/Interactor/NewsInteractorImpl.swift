//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


class NewsInteractorImpl: NewsInteractor {
    
    var loadingResultInternal: Variable<LoadingResult> = Variable(.error(text: "Loading has not started yet"))
    
    var loadingResult: Observable<LoadingResult> {
        return loadingResultInternal.asObservable()
    }

    var api: NewsApi = NewsApiImpl()
    
    func loadNews(date: Date) {
        api.news(date: date) { [weak self] (news, error) in
            if let news = news {
                self?.loadingResultInternal.value = .success(news: news, date: date)
            } else {
                let errorText = error ?? "Unknown error"
                self?.loadingResultInternal.value = .error(text: errorText)
            }
        }
    }
}
