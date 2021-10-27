//
//  ViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        var url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let aaa = url.appendingPathComponent("willConvert")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        let bbb = aaa.appendingPathComponent("lame_MP3").appendingPathExtension("mp3")
        let testURL = Bundle.main.url(forResource: "sampleMP3", withExtension: "mp3")
        AudioConverter(inputURL: testURL!).convertMP3(output: bbb, onProgress: { num in
            print(num)
        }, onComplete: {print("end")})
        
    }
}
