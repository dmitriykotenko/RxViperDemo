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
    
    /// Ссылка на компоненты модуля.
    var moduleReference: Any?
    
    var readySubject = PublishSubject<Void>()
    var ready: Single<Void> {
        return readySubject.asSingle()
    }
    
    var viewModel: Variable<NewsViewState> = Variable(NewsViewState(date: Date(), newsState: .loading))
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        
        readySubject.on(.next())
        readySubject.on(.completed)
    }
    
    private func setupBindings() {
        viewModel.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.update($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func update(_ state: NewsViewState) {
        titleLabel.text = state.title
        dateButton.setTitle(state.selectDateButtonTitle, for: UIControlState.normal)
        dateButton.isHidden = state.isSelectDateButtonHidden
        
        newsLabel.text = state.text
        newsLabel.alpha = state.textAlpha
        
        reloadButton.isHidden = state.isLoadButtonHidden
        reloadButton.isEnabled = state.isLoadButtonEnabled
    }

    var loadButtonTapped: Observable<Void> {
        return reloadButton.rx.tap.asObservable()
    }
    
    var selectDateButtonTapped: Observable<Void> {
        return dateButton.rx.tap.asObservable()
    }
}
