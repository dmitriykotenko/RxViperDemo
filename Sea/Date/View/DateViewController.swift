//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxCocoa
import RxSwift


class DateViewController: UIViewController, DateView {
    
    @IBOutlet
    private var datePicker: UIDatePicker!

    @IBOutlet
    private var okButton: UIButton!

    var initialDate: Variable<Date> = Variable(Date())
    var viewIsReadySubject: PublishSubject<Void> = PublishSubject()
    var viewIsReady: Single<Void> {
        return viewIsReadySubject.asSingle()
    }
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButtonTaps
            .debug("OK button tap caught in view controller.")
            .subscribe(onNext: { [unowned self] in
//                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewIsReadySubject.on(.next())
        viewIsReadySubject.on(.completed)
    }
    
    private func setupBindings() {
        initialDate.asObservable()
            .skip(1)
            .bind(to: datePicker.rx.date)
            .disposed(by: disposeBag)
    }
    
    var date: Observable<Date> {
        return datePicker.rx.date.asObservable()
    }
    
    var okButtonTaps: Observable<Void> {
        return okButton.rx.tap
            .debug("OK button tap - RAW.")
            .asObservable()
    }
}
