//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift
import RxCocoa


class NewsViewController: UIViewController {
    
    @IBOutlet
    private var titleLabel: UILabel!
    
    @IBOutlet
    private var dateButton: UIButton!

    @IBOutlet
    private var newsLabel: UILabel!

    @IBOutlet
    private var reloadButton: UIButton!
    
    var moduleReference: Any?
    
    var readySubject = PublishSubject<Void>()
    var ready: Single<Void> {
        return readySubject.asSingle()
    }
    
    var moduleAssembly: NewsAssembly!
    private var disposeBag = DisposeBag()
    
    var loadButtonTapped: Observable<Void> {
        return reloadButton.rx.tap.asObservable()
    }
    
    var selectDateButtonTapped: Observable<Void> {
        return dateButton.rx.tap.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readySubject.on(.next())
        readySubject.on(.completed)
    }
    
    func setupBindings(date: Observable<Date>, newsState: Observable<NewsState>) {
        date.asObservable()
            .map { [unowned self] in self.formatDate($0) }
            .bind(to: dateButton.rx.title())
            .disposed(by: disposeBag)
        
        newsState.asDriver(onErrorJustReturn: .loading)
            .drive(onNext: displayNewsState )
            .disposed(by: disposeBag)
    }
    
    func displayNewsState(_ state: NewsState) {
        switch state {
        case .loading:
            titleLabel.text = "Загружаем новости..."
            dateButton.isHidden = true
            newsLabel.alpha = 0.25
            reloadButton.isEnabled = false
            reloadButton.isHidden = true
        case let .success(news, _):
            titleLabel.text = "Новости за "
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
}
