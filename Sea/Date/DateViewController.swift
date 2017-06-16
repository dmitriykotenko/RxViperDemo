//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxCocoa
import RxSwift


class DateViewController: UIViewController {
    
    var moduleReference: Any?
    
    @IBOutlet
    private var datePicker: UIDatePicker!

    @IBOutlet
    private var okButton: UIButton!

    var readySubject: PublishSubject<Void> = PublishSubject()
    var ready: Single<Void> {
        return readySubject.asSingle()
    }
    
    var initialDate: PublishSubject<Date> = PublishSubject()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialDate
            .bind(to: datePicker.rx.date)
            .disposed(by: disposeBag)
        
        readySubject.on(.next())
        readySubject.on(.completed)
    }
    
    var date: Observable<Date> {
        return datePicker.rx.date.asObservable()
    }
    
    var okButtonTapped: Observable<Void> {
        return okButton.rx.tap.asObservable()
    }
}
