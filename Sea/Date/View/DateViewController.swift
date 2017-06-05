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

    var readySubject: PublishSubject<Void> = PublishSubject()
    var ready: Single<Void> {
        return readySubject.asSingle()
    }
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readySubject.on(.next())
        readySubject.on(.completed)
    }
    
    func setupInitialState(date: Date) {
        datePicker.date = date
    }
    
    var date: Observable<Date> {
        return datePicker.rx.date.asObservable()
    }
    
    var okButtonTapped: Observable<Void> {
        return okButton.rx.tap.asObservable()
    }
}
