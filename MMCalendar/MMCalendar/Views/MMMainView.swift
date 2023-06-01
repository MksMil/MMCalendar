import UIKit

protocol MyClock: UIView {
    func updateFrame()
}

class MMMainView: UIView {
// MARK: - Properties
    //constants
    private let inset: CGFloat = 20
    private let controlsViewHeight: CGFloat = 50
    
    // fraction values mades for animation value 0 means that visualization view is not on screen,
    // value 1 - interaction view is not on screen
    var viewsFractionVerticalRegular: CGFloat = 1 / 2 {
        didSet{
            NSLayoutConstraint.deactivate([visualizationViewHeightConstrain])
            visualizationViewHeightConstrain = getHeightConstraint()
            NSLayoutConstraint.activate([visualizationViewHeightConstrain])
        }
    }
    var viewsFractionVerticalCompact: CGFloat = 1 / 2 {
        didSet{
            NSLayoutConstraint.deactivate([visualizationViewWidthConstrain])
            visualizationViewWidthConstrain = getWidthConstraint()
            NSLayoutConstraint.activate([visualizationViewWidthConstrain])
        }
    }
    
    // views
    var visualizationView: UIView! = nil
    var interactionView: UIView! = nil
    var controlsView: UIView! = nil
    var clock: MyClock! = nil
    
    //constraints
    private lazy var visualizationViewHeightConstrain: NSLayoutConstraint = {
        return getHeightConstraint()
    }()
    
    private lazy var visualizationViewWidthConstrain: NSLayoutConstraint = {
        return getWidthConstraint()
    }()
    
    private var clockConstraints: [NSLayoutConstraint] = []
    
    private lazy var staticConstraints: [NSLayoutConstraint] = {
        let staticConstraints = [
            visualizationView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            visualizationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: inset),
            
            interactionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -inset),
            interactionView.bottomAnchor.constraint(equalTo: controlsView.topAnchor, constant:-inset),
            
            controlsView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: inset / 2),
            controlsView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -inset / 2),
            controlsView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -inset / 2),
            controlsView.heightAnchor.constraint(equalToConstant: controlsViewHeight)
        ]
        return staticConstraints
    }()
    
    private lazy var portraitConstraints: [NSLayoutConstraint] = {
        let portraitConstraints = [
            visualizationView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            interactionView.leadingAnchor.constraint(equalTo: visualizationView.leadingAnchor),
            interactionView.topAnchor.constraint(equalTo: visualizationView.bottomAnchor, constant: inset),
        ]
        return portraitConstraints
    }()
    
    private lazy var landscapeConstraints: [NSLayoutConstraint] = {
        let landscapeConstraints = [
            visualizationView.trailingAnchor.constraint(equalTo: interactionView.leadingAnchor, constant: -inset),
            visualizationView.bottomAnchor.constraint(equalTo: controlsView.topAnchor, constant: -inset),
            interactionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: inset)
        ]
        return landscapeConstraints
    }()
    
    // MARK: - Initialization
    convenience init(conteinerView: UIView,visualizationView: UIView, interactionView: UIView, controlsView: UIView){
        self.init(frame: conteinerView.frame)
        self.visualizationView = visualizationView
        self.interactionView = interactionView
        self.controlsView = controlsView
        
    }
    
  // MARK: - Methods
    // calculation of initial state and animation depending of portrait/landscape
    private func getHeightConstraint() -> NSLayoutConstraint{
        return traitCollection.verticalSizeClass == .regular ?
        visualizationView.heightAnchor.constraint(
            equalToConstant: (self.safeAreaLayoutGuide.layoutFrame.height - controlsViewHeight - 4 * inset) * viewsFractionVerticalRegular):
        visualizationView.heightAnchor.constraint(
            equalToConstant: self.safeAreaLayoutGuide.layoutFrame.height - controlsViewHeight - 3 * inset )
    }
    
    private func getWidthConstraint() -> NSLayoutConstraint{
        return traitCollection.verticalSizeClass == .compact ?
        visualizationView.widthAnchor.constraint(
            equalToConstant: (self.safeAreaLayoutGuide.layoutFrame.width - 3 * inset) * viewsFractionVerticalCompact):
        visualizationView.widthAnchor.constraint(
            equalToConstant: self.safeAreaLayoutGuide.layoutFrame.width - 2 * inset)
    }
    // setup constraints
    private func setupMainViewLayout(state: State){
        NSLayoutConstraint.activate(
            staticConstraints + ((UITraitCollection.current.verticalSizeClass == .regular) ?
                                        portraitConstraints  + [visualizationViewHeightConstrain]:
                                        landscapeConstraints + [visualizationViewWidthConstrain]))
    }
    
    // MARK: - Setup Main View
    func setupMainView(state: State){
        addVisualizationView(state: state)
        addInteractionView(state: state)
        addControlsView(state: state)
        
        setupMainViewLayout(state: state)
        
        //setup analog clock
        clock = AnalogClock()
//        clock = DigitalClock()
            clock.translatesAutoresizingMaskIntoConstraints = false
            visualizationView.addSubview(clock)
            clockConstraints = [
                clock.leadingAnchor.constraint(equalTo: visualizationView.leadingAnchor),
                clock.trailingAnchor.constraint(equalTo: visualizationView.trailingAnchor),
                clock.topAnchor.constraint(equalTo: visualizationView.topAnchor),
                clock.bottomAnchor.constraint(equalTo: visualizationView.bottomAnchor)]
            NSLayoutConstraint.activate(clockConstraints)
        
        //setup digital clock
        
        
    }
    
    //prepearing and add subviews
    private func addVisualizationView(state: State){
        visualizationView = UIView()
        visualizationView.layer.cornerRadius = 10
        visualizationView.layer.borderWidth = 1
        visualizationView.layer.borderColor = UIColor.black.cgColor
        visualizationView.backgroundColor = UIColor(white: 0, alpha: 0.25)
        visualizationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(visualizationView)
    }
    
    private func addInteractionView(state: State){
        interactionView = UIView()
        interactionView.layer.cornerRadius = 10
        interactionView.layer.borderWidth = 1
        interactionView.layer.borderColor = UIColor.black.cgColor
        interactionView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        interactionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(interactionView)
    }
    
    private func addControlsView(state: State){
        controlsView = UIView()
        controlsView.layer.cornerRadius = 5
        controlsView.backgroundColor = UIColor(white: 0, alpha: 0.75)
        controlsView.layer.borderWidth = 3
        controlsView.layer.borderColor = UIColor.black.cgColor
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(controlsView)
    }
    
    // MARK: - change portrait/landscape
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass{
            changeFrame()
            if traitCollection.verticalSizeClass == .regular{
                NSLayoutConstraint.deactivate(landscapeConstraints + [visualizationViewWidthConstrain])
                NSLayoutConstraint.activate(portraitConstraints + [visualizationViewHeightConstrain])
            }else{
                NSLayoutConstraint.deactivate(portraitConstraints + [visualizationViewHeightConstrain])
                NSLayoutConstraint.activate(landscapeConstraints + [visualizationViewWidthConstrain] )
            }
            clock.updateFrame()
            setNeedsLayout()
        }
    }
    
    // changing orientation dont change main view's frame. change frame manualy
    private func changeFrame(){
        let newHeight = frame.width
        let newWidth = frame.height
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: newWidth, height: newHeight))
    }
}
