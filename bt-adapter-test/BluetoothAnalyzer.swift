//
//  BluetoothAnalyzer.swift
//  bt-adapter-test
//
//  Created by Tomasz Oraczewski on 10/12/2020.
//

import Foundation
import CoreBluetooth

class BluetoothAnalyzer: NSObject, CBCentralManagerDelegate {
    var onADVCount: ((Int) -> Void)?
    var onSilentWindow: (() -> Void)?
    var onBluetoothReset: (() -> Void)?
    
    private var timer: Timer?
    private var adVCounter = 0
    private var manager: CBCentralManager?
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        if case .poweredOn = manager?.state {
            manager?.scanForPeripherals(withServices: [], options: nil)
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            manager?.scanForPeripherals(withServices: [], options: nil)
        } else if central.state == .resetting {
            onBluetoothReset?()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        adVCounter += 1
    }
    
    @objc private func onTick(timer: Timer) {
        onADVCount?(adVCounter)
        if adVCounter == 0 {
            onSilentWindow?()
        }
        adVCounter = 0
    }
}
