//
//  PageViewController.swift
//  freee_SelectionSubject_AccountBook
//
//  Created by 大林拓実 on 2019/05/21.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    // If you operate the location of pageControl, please use this and set the desired location (use CGRect())
    var pageViewControllerArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataSource = self
        // storyboard->optional value
        // identifier->Storyboard ID's name
        let MainViewStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SummaryViewStoryboard : UIStoryboard = UIStoryboard(name: "SummaryView", bundle: nil)
        
        let MainViewController = MainViewStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let SuumaryViewController = SummaryViewStoryboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        
        pageViewControllerArray = [MainViewController, SuumaryViewController]
        
        self.setViewControllers([pageViewControllerArray.first!], direction: .forward, animated: true, completion: nil)
        
        //E merge pageControl
//        let pageControl = UIPageControl.appearance()
//        pageControl.isOpaque = false //Unclear mode->false
//        pageControl.currentPageIndicatorTintColor = UIColor.blue
//        pageControl.pageIndicatorTintColor = UIColor.gray
//        pageControl.backgroundColor = UIColor.init(white: 1, alpha: 0.8) //background color->alpha
//        pageControl.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = .clear
    }
    
    
    
    
    // Return the current page index
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerArray.count
    }
    
    // Return the first index of pageControl
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
    
    /*
     func getFirst() -> LoginViewController {
     return storyboard!.instantiateViewController(withIdentifier: pages.first!) as! LoginViewController
     }
     
     func getSecond() -> RankingViewController {
     return storyboard!.instantiateViewController(withIdentifier: "RankingViewController") as! RankingViewController
     }
     */
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//State the DataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? { //when swiping left, the following action is performed
        //current page index
        let index = pageViewControllerArray.firstIndex(of: viewController)!
        
        if index > 0 {
            return pageViewControllerArray[index - 1]
        }
        else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? { //when swiping right, the following action is performed
        //current page index
        let index = pageViewControllerArray.firstIndex(of: viewController)!
        
        if index < pageViewControllerArray.count - 1 {
            return pageViewControllerArray[index + 1]
        }
        else {
            return nil
        }
    }
    
    
}

/*
 extension PageViewController: UIPageViewControllerDataSource {
 func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
 if viewController.isKind(of: RankingViewController.self) {
 return getFirst()
 }
 else {
 return nil
 }
 }
 
 func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
 if viewController.isKind(of: LoginViewController.self) {
 return getSecond()
 }
 else {
 return nil
 }
 }
 }
 */
