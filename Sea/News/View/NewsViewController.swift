//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift
import RxCocoa


class NewsViewController: UIViewController, NewsView {
    
    @IBOutlet
    private var titleLabel: UILabel!
    
    @IBOutlet
    private var dateButton: UIButton!

    @IBOutlet
    private var newsLabel: UILabel!

    @IBOutlet
    private var reloadButton: UIButton!
    
    var viewIsReadySubject = PublishSubject<Void>()
    var viewIsReady: Observable<Void> {
        return viewIsReadySubject.asObservable()
    }
    
    var state: Variable<NewsViewState> = Variable(.loading)
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        
        viewIsReadySubject.on(.next())
        viewIsReadySubject.on(.completed)
    }
    
    func setupBindings() {
        state.asDriver()
            .drive(onNext: displayState )
            .disposed(by: disposeBag)
    }
    
    func displayState(_ state: NewsViewState) {
        switch state {
        case .loading:
            titleLabel.text = "Загружаем новости..."
            dateButton.isHidden = true
            newsLabel.alpha = 0.25
            reloadButton.isEnabled = false
            reloadButton.isHidden = true
        case let .success(news, date):
            titleLabel.text = "Новости за "
            dateButton.setTitle(formatDate(date), for: UIControlState.normal)
            dateButton.isHidden = false
            newsLabel.alpha = 1
            newsLabel.text = news.joined(separator: "\n")
            reloadButton.isEnabled = true
            reloadButton.isHidden = false
        case let .error(errorText):
            titleLabel.text = errorText
            dateButton.isHidden = true
            newsLabel.alpha = 1
            newsLabel.text = nil
            reloadButton.isEnabled = true
            reloadButton.isHidden = false
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru-RU")
        
        return dateFormatter.string(from: date)
    }
    
    var loadButtonTaps: Observable<Void> {
        return reloadButton.rx.tap.asObservable()
    }
    
    var selectDateButtonTaps: Observable<Void> {
        return dateButton.rx.tap.asObservable()
    }
}
