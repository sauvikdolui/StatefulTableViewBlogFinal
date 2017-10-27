//
//  SDStateTableView.swift
//  SDStateTableView
//
//  Created by Sauvik Dolui on 13/10/17.
//

import Foundation
public enum SDStateTableViewState {
    case dataAvailable
    case loading(message: String)
    case withImage(image: String?, title: String?, message: String)
    case withButton(errorImage: String?, title: String?, message: String, buttonTitle: String,
        buttonConfig: (UIButton) -> Void, retryAction: () -> Void)
    case unknown
}

@IBDesignable
public class SDStateTableView: UITableView {
    
    @IBInspectable
    public var stateViewCenterPositionOffset: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable
    public var spinnerColor: UIColor = UIColor.lightGray {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateViewTitleColor: UIColor = UIColor.darkGray {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateViewSubtitleColor: UIColor = UIColor.lightGray {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var buttonColor: UIColor = UIColor.darkGray {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable
    public var stateLabelTitleFontFamily: String = "HelveticaNeue-Bold" {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateLabelSubtitleFontFamily: String = "HelveticaNeue-Light" {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var retryButtonFontFamily: String = "HelveticaNeue-Regular" {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateLabelTitleFontSize: CGFloat = 20.0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateLabelSubtitleFontSize: CGFloat = 16.0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var buttonFontSize: CGFloat = 16.0 {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable
    public var buttonSize: CGSize = CGSize(width: 200.0, height: 44.0) {
        didSet {
            setUp()
        }
    }
    
    // MARK: Spacing
    @IBInspectable
    public var titleStackSpacing: CGFloat = 8.0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var imageTitleStackSpacing: CGFloat = 16.0 {
        didSet {
            setUp()
        }
    }
    
    var originalSeparatorStyle =  UITableViewCellSeparatorStyle.singleLine
    var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var dataStateTitleLabel = UILabel.autolayoutView()
    var dataStateSubtitleLabel = UILabel.autolayoutView()
    
    var stateImageView = UIImageView.autolayoutView()
    
    var stackView: UIStackView =  UIStackView.autolayoutView()
    var titleStackView: UIStackView =  UIStackView.autolayoutView()
    
    var actionButton = UIButton.autolayoutView()
    
    var buttonAction: (() -> Void)?
    
    public var currentState: SDStateTableViewState = .unknown
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUp()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setUp()
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        switch self.currentState {
        case .loading(let message):
            self.dataStateSubtitleLabel.text = message
        default:
            ()
        }
        setUp()
        
    }
    // MARK: - Custom Setup
    private func setUp() {
        
        // Loading state
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.color = spinnerColor
        spinnerView.hidesWhenStopped = true
        
        dataStateTitleLabel.textColor = stateViewTitleColor
        dataStateTitleLabel.numberOfLines = 0
        dataStateTitleLabel.textAlignment = .center
        dataStateTitleLabel.lineBreakMode = .byWordWrapping
        dataStateTitleLabel._setWidth(width: UIScreen.main.bounds.width * 0.80)
        dataStateTitleLabel.font = UIFont(name: stateLabelTitleFontFamily, size: stateLabelTitleFontSize)
        
        dataStateSubtitleLabel.textColor = stateViewSubtitleColor
        dataStateSubtitleLabel.numberOfLines = 0
        dataStateSubtitleLabel.textAlignment = .center
        dataStateSubtitleLabel.lineBreakMode = .byWordWrapping
        dataStateSubtitleLabel._setWidth(width: UIScreen.main.bounds.width * 0.80)
        dataStateSubtitleLabel.font = UIFont(name: stateLabelSubtitleFontFamily, size: stateLabelSubtitleFontSize)
        
        titleStackView.axis  = .vertical
        titleStackView.distribution  = .equalSpacing
        titleStackView.alignment = .center
        titleStackView.spacing = titleStackSpacing
        titleStackView.addArrangedSubview(dataStateTitleLabel)
        titleStackView.addArrangedSubview(dataStateSubtitleLabel)
        
        actionButton.titleLabel?.font = UIFont(name: retryButtonFontFamily, size: buttonFontSize)
        actionButton.setTitleColor(buttonColor, for: .normal)
        actionButton.setNeedsLayout()
        actionButton._setSize(size: CGSize(width: buttonSize.width, height: buttonSize.height))
        actionButton.layer.cornerRadius = 5.0
        actionButton.layer.borderWidth = 1.0
        actionButton.layer.borderColor = buttonColor.cgColor
        actionButton.addTarget(self, action: #selector(self.retryButtonTapped(_:)), for: .touchUpInside)
        
        
        stackView.axis  = .vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = imageTitleStackSpacing
        
        
        stackView.addArrangedSubview(spinnerView)
        stackView.addArrangedSubview(stateImageView)
        stackView.addArrangedSubview(titleStackView)
        
        stackView.addArrangedSubview(actionButton)
        addSubview(stackView)
        
        //Constraints
        stackView._setCenterAlignWith(view: self, offset: stateViewCenterPositionOffset)
        
        //
        if case SDStateTableViewState.withButton(_, _, _, _, _, _) = currentState {
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }
    
    // Mark: - Deinit
    deinit {
        // Deinitialization code goes here
    }
    
    public func setState(state: SDStateTableViewState) {
        self.currentState =  state
        reloadData()
        switch state {
            
        case .dataAvailable:
            configureForShowinData()
        case .loading(let message):
            configureForLoadingData(message: message)
        case .withImage(let image, let title, let message):
            configureWith(imageFile: image, title: title, message: message)
        case .withButton(let errorImage, let title, let message, let buttonTitle,
                         let buttonConfig, let buttonAction):
            configWithButton(image: errorImage, title: title, message: message,
                             buttonTitle: buttonTitle,
                             buttonConfig: buttonConfig,
                             buttonTapAction: buttonAction)
        case .unknown:
            ()
        }
        self.setNeedsLayout()
    }
    
    @objc func retryButtonTapped( _ sender: UIButton) {
        guard let action = self.buttonAction else {
            print("Retry Action not Found")
            return
        }
        action()
    }
    
    private func configureForLoadingData(message: String) {
        
        stateImageView.isHidden = true
        stackView.isHidden = false
        
        spinnerView.isHidden = false
        dataStateTitleLabel.isHidden = true
        actionButton.isHidden = true
        
        spinnerView.startAnimating()
        dataStateSubtitleLabel.text = message
    }
    
    private func configureWith(imageFile: String?, title: String?, message: String) {
        
        // Image View
        if let imageFile = imageFile {
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: imageFile)
        } else {
            stateImageView.isHidden  = true
        }
        
        // Title Label
        if let title = title {
            dataStateTitleLabel.isHidden = false
            dataStateTitleLabel.text = title
        } else {
            dataStateTitleLabel.isHidden = true
        }
        
        actionButton.isHidden = true
        spinnerView.isHidden = true
        stackView.isHidden = false
        
        dataStateSubtitleLabel.isHidden = false
        dataStateSubtitleLabel.text = message
    }
    
    private func configWithButton(image: String?, title: String?, message: String,
                                  buttonTitle: String,
                                  buttonConfig: (UIButton) ->Void,
                                  buttonTapAction: @escaping () -> Void) {
        
        configureWith(imageFile: image, title: title, message: message)
        buttonConfig(actionButton)
        actionButton.isHidden = false
        buttonAction = buttonTapAction
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    private func configureForShowinData() {
        stackView.isHidden = true
    }
}
