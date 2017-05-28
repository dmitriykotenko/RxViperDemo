//
//  Copyright © 2017 Tutu.ru. All rights reserved.
//

import RxSwift
import RxCocoa


class NewsViewController: UIViewController, NewsView {
    
    var dateLabel: UILabel!
    var newsLabel: UILabel!
    var reloadButton: UIButton!
    
    var viewIsReadyInternal = PublishSubject<Void>()
    var viewIsReady: Observable<Void> {
        return viewIsReadyInternal.asObservable()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .orange
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.boldSystemFont(ofSize: 28)
        view.addSubview(dateLabel)
        
        newsLabel = UILabel()
        newsLabel.translatesAutoresizingMaskIntoConstraints = false
        newsLabel.numberOfLines = 0
        newsLabel.lineBreakMode = .byWordWrapping
        view.addSubview(newsLabel)
        
        reloadButton = UIButton()
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.layer.cornerRadius = 12
        reloadButton.backgroundColor = .cyan
        reloadButton.setTitle("Загрузить новые новости", for: UIControlState.normal)
        view.addSubview(reloadButton)
        
        placeSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewIsReadyInternal.on(.next())
        viewIsReadyInternal.on(.completed)
    }
    
    func placeSubviews() {
        alignSubviewHorizontally(subview: dateLabel)
        alignSubviewHorizontally(subview: newsLabel)
        alignSubviewHorizontally(subview: reloadButton)
        
        pinSubviewToTop(subview: dateLabel)
        pinTopSubview(topSubview: dateLabel, toBottomSubview: newsLabel)
        pinTopSubview(topSubview: newsLabel, toBottomSubview: reloadButton)
        pinSubviewToBottom(subview: reloadButton)
    }
    
    func alignSubviewHorizontally(subview: UIView) {
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "|-20-[subview]-20-|",
            options: [],
            metrics: nil,
            views: ["subview": subview])
        
        view.addConstraints(constraints)
    }
    
    func pinSubviewToTop(subview: UIView) {
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[subview]",
            options: [],
            metrics: nil,
            views: ["subview": subview])
        
        view.addConstraints(constraints)
    }
    
    func pinSubviewToBottom(subview: UIView) {
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[subview]-20-|",
            options: [],
            metrics: nil,
            views: ["subview": subview])
        
        view.addConstraints(constraints)
    }
    
    func pinTopSubview(topSubview: UIView, toBottomSubview bottomSubview: UIView) {
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[top]-20-[bottom]",
            options: [],
            metrics: nil,
            views: ["top": topSubview, "bottom": bottomSubview])
        
        view.addConstraints(constraints)
    }
    
    func setState(_ state: NewsViewState) {
        switch state {
        case .loading: showLoadingState()
        case let .success(news, date): showNews(news: news, date: date)
        case let .error(errorText): showConnectionError(errorText: errorText)
        }
    }
    
    private func showLoadingState() {
        dateLabel.text = "Загружаем новости..."
        newsLabel.alpha = 0.25
        reloadButton.isEnabled = false
    }
    
    private func showConnectionError(errorText: String) {
        dateLabel.text = errorText
        newsLabel.alpha = 1
        newsLabel.text = nil
        reloadButton.isEnabled = true
    }
    
    private func showNews(news: News, date: Date) {
        dateLabel.text = date.description
        newsLabel.alpha = 1
        newsLabel.text = news.joined(separator: "\n")
        reloadButton.isEnabled = true
    }
    
    var loadButtonTaps: Observable<Void> {
        return reloadButton.rx.tap.asObservable()
    }
}
