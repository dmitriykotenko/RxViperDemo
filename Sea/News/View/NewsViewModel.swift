//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift


struct NewsViewState {    
    
    let title: String?
    let text: String?
    let textAlpha: CGFloat
    let isLoadButtonHidden: Bool
    let isLoadButtonEnabled: Bool
    let selectDateButtonTitle: String?
    let isSelectDateButtonHidden: Bool
    
    private var disposeBag = DisposeBag()
    
    init(date: Date, newsState: NewsState) {
        switch newsState {
        case .loading:
            title = "Загружаем новости..."
            isSelectDateButtonHidden = true
            textAlpha = 0.25
            text = nil
            isLoadButtonEnabled = false
            isLoadButtonHidden = true
        case let .success(news, _):
            title = "Новости за "
            isSelectDateButtonHidden = false
            textAlpha = 1
            text = news.joined(separator: "\n")
            isLoadButtonEnabled = true
            isLoadButtonHidden = false
        case let .error(errorText):
            title = errorText
            isSelectDateButtonHidden = true
            textAlpha = 1
            text = nil
            isLoadButtonEnabled = true
            isLoadButtonHidden = false
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru-RU")
        
        selectDateButtonTitle = dateFormatter.string(from: date)
    }
}
