//
//  ViewController.swift
//  bt-adapter-test
//
//  Created by Tomasz Oraczewski on 10/12/2020.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let advInfoLabel = UILabel()
    let advLabel = UILabel()
    
    let silentWindowsInfoLabel = UILabel()
    let silentWindowsLabel = UILabel()
    
    let resetInfoLabel = UILabel()
    let resetsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        let analyzer = BluetoothAnalyzer()
        analyzer.onADVCount = { count in
            self.advLabel.text = String(count)
        }
    }
    
    private func initUI() {
        view.backgroundColor = .white
        
        view.addSubview(advInfoLabel)
        advInfoLabel.text = "ADV count in last 5s:"
        advInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().offset(20)
        }
        view.addSubview(advLabel)
        advLabel.text = "0"
        advLabel.snp.makeConstraints { make in
            make.centerY.equalTo(advInfoLabel.snp.centerY)
            make.leading.equalTo(advInfoLabel.snp.trailing).offset(5)
        }
        
        view.addSubview(silentWindowsInfoLabel)
        silentWindowsInfoLabel.text = "Last windows without ADV detected:"
        silentWindowsInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(advLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        view.addSubview(silentWindowsLabel)
        silentWindowsLabel.text = "None"
        silentWindowsLabel.numberOfLines = 0
        silentWindowsLabel.snp.makeConstraints { make in
            make.top.equalTo(silentWindowsInfoLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(resetInfoLabel)
        resetInfoLabel.text = "Last bluetooth adapter resets:"
        resetInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(silentWindowsLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        view.addSubview(resetsLabel)
        resetsLabel.text = "None"
        resetsLabel.numberOfLines = 0
        resetsLabel.snp.makeConstraints { make in
            make.top.equalTo(resetInfoLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
        }
    }
}
