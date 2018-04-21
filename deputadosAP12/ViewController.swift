//
//  ViewController.swift
//  deputadosAP12
//
//  Created by Lucas de Brito on 07/04/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}



