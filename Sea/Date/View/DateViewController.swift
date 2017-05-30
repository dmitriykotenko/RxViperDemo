//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxCocoa
import RxSwift


class DateViewController: UIViewController, DateView {
    
    @IBOutlet var topicField: UITextField!
    @IBOutlet var okButton: UIButton!

    var initialDate: Variable<String> = Variable("")
    var viewIsReady: PublishSubject<Void> = PublishSubject()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewIsReady.on(.next())
    }
    
    private func setupBindings() {
        initialDate.asObservable()
            .skip(1)
            .bind(to: topicField.rx.text)
            .disposed(by: disposeBag)
    }
    
    var topic: Observable<String> {
        return topicField.rx.text.map { $0 ?? "" }.asObservable()
    }
    
    var okButtonTaps: Observable<Void> {
        return okButton.rx.tap.asObservable()
    }
}
