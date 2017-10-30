//
//  SegueFromLeft.swift
//  CACproject
//
//  Created by Timothy Park on 10/16/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        /*
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .transitionCurlUp,  animations: { dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { finished in src.present(dst, animated: false, completion: nil)
        } )
 */
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .transitionCurlUp,  animations: { dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { finished in src.present(dst, animated: false, completion: nil)
        } )
    }
}

class unwindScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        /*
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
         */
 
        /*
        toViewController.view.transform = CGAffineTransform(translationX: toViewController.view.frame.size.width, y: 0)
        toViewController.view.center = originalCenter
         */
 
 
        //containerView?.addSubview(toViewController.view)
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut,  animations: { fromViewController.view.transform = CGAffineTransform(translationX: fromViewController.view.frame.size.width, y: 0)
        }, completion: { success in fromViewController.dismiss(animated: false, completion: nil)
        })
        
        /*
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut,  animations: { fromViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { finished in fromViewController.present(fromViewController, animated: false, completion: nil)
        } ) */
        
    }
    
}
