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

    var viewIsReadySubject: PublishSubject<Void> = PublishSubject()
    var viewIsReady: Single<Void> {
        return viewIsReadySubject.asSingle()
    }
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewIsReadySubject.on(.next())
        viewIsReadySubject.on(.completed)
    }
    
    func setupInitialState(date: Date) {
        datePicker.date = date
    }
    
    var date: Observable<Date> {
        return datePicker.rx.date.asObservable()
    }
    
    var okButtonTaps: Observable<Void> {
        return okButton.rx.tap.asObservable()
    }
}
