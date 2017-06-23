//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


enum LoadingResult {
    case success(news: News, date: Date)
    case error(text: String)
}

class NewsInteractor {
    
    private var api: NewsApi = NewsApiImpl()

    var newsLoaded: Observable<LoadingResult>!

    init() {}
    
    func setupBindings(_ loadNewsInput: Observable<Date>) {
        newsLoaded = loadNewsInput.flatMap{ [unowned self] date -> Observable<LoadingResult> in
            return self.loadNews(date: date)
        }
    }
    
    private func loadNews(date: Date) -> Observable<LoadingResult> {
        return Observable.create{ [unowned self] observer in
            self.api.news(date: date) { (news, error) in
                if let news = news {
                    observer.onNext(.success(news: news, date: date))
                } else {
                    let errorText = error ?? "Неизвестная ошибка"
                    observer.onNext(.error(text: errorText))
                }
            }
            return Disposables.create()
        }
        
    }
}
