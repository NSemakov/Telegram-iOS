import UIKit

public final class ListViewScroller: UIScrollView, UIGestureRecognizerDelegate {
    override public init(frame: CGRect) {
        super.init(frame: frame)

//        print("!! ListViewScroller: \(self)")
        
        self.scrollsToTop = false
        self.contentInsetAdjustmentBehavior = .never
    }
    var firstTime = true
    public override var contentOffset: CGPoint {
        didSet {
            if !firstTime && contentOffset.y > -60 {
                let _ = 2
            } else if firstTime && contentOffset.y < -79 {
                firstTime = false
            }
        }
    }
    var firstTime2 = true
    public override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: animated)

        if !firstTime2 && contentOffset.y > -60 {
            let _ = 2
        } else if firstTime2 && contentOffset.y < -79 {
            firstTime2 = false
        }
    }

//    var firstTime3 = true
    public override var contentInset: UIEdgeInsets {

        didSet {
            print("!! ListViewScroller contentInset: \(contentInset)")
//            if !firstTime3 && contentOffset.y > -60 {
//                let _ = 2
//            } else if firstTime3 && contentOffset.y < -79 {
//                firstTime = false
//            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is ListViewTapGestureRecognizer {
            return true
        }
        return false
    }
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer, let gestureRecognizers = gestureRecognizer.view?.gestureRecognizers {
            for otherGestureRecognizer in gestureRecognizers {
                if otherGestureRecognizer !== gestureRecognizer, let panGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer, panGestureRecognizer.minimumNumberOfTouches == 2 {
                    return gestureRecognizer.numberOfTouches < 2
                }
            }
            
            if let view = gestureRecognizer.view?.hitTest(gestureRecognizer.location(in: gestureRecognizer.view), with: nil) as? UIControl {
                return !view.isTracking
            }
            
            return true
        } else {
            return true
        }
    }
    
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
    
    var forceDecelerating = false
    public override var isDecelerating: Bool {
        return self.forceDecelerating || super.isDecelerating
    }
}
