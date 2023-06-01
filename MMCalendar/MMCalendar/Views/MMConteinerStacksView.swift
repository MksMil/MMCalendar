import UIKit

class MMConteinerStacksView: UIView {
    // MARK: - Properties
    //constants
    private let inset: CGFloat = 20
    private let controlsViewHeight: CGFloat = 50
    private lazy var controlsViewWidth: CGFloat = {
        return self.frame.width - 2 * inset
    }()
    
    // views
    var visualizationView: UIView! = nil
    var interactionView: UIView! = nil
    var controlsView: UIView! = nil
    
    //stacks
    
    private var verticalStackView: UIStackView! = nil
    private var contentStackView: UIStackView! = nil
    
    //width or height content view scale factor, depending of orientation
    private var _scaleFactor: CGFloat = 0.5
    var scaleFactor: CGFloat {
        set{
            _scaleFactor = newValue
        }
        get {
            return _scaleFactor
        }
    }
    
    // MARK: - Initialization
    convenience init(conteinerView: UIView,visualizationView: UIView, interactionView: UIView, controlsView: UIView){
        self.init(frame: conteinerView.frame)
        self.visualizationView = visualizationView
        self.interactionView = interactionView
        self.controlsView = controlsView
        
    }
    
    // MARK: - SetupViews
    func setupMainView(state: State){
        makeStacks()
    }
    private func makeControlsView(){
        controlsView.frame.size = CGSize(width: controlsViewWidth,
                                         height: controlsViewHeight)
        print(controlsView.frame)
    }
    
    private func makeStacks(){
        
        contentStackView = UIStackView(arrangedSubviews: [visualizationView,interactionView])
        checkContentStackViewAxis()
        contentStackView.distribution = .fillProportionally
//        contentStackView.spacing = 5
        contentStackView.contentMode = .scaleToFill //?

        verticalStackView = UIStackView(arrangedSubviews: [contentStackView,controlsView])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
//        verticalStackView.spacing = inset
        addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        makeVerticalStackConstraints()
        setNeedsLayout()
    }

    private func makeVerticalStackConstraints(){
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: inset),
            verticalStackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: inset),
            verticalStackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -inset),
            verticalStackView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -inset)
        ])
    }
    
    private func checkContentStackViewAxis(){
        contentStackView.axis = UITraitCollection.current.verticalSizeClass == .regular ?
            .vertical: .horizontal
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        checkContentStackViewAxis()

    }
}
