import Foundation
import CoreBluetooth

class BluetoothAnalyzer: NSObject, CBCentralManagerDelegate {
    var onADVCount: ((Int) -> Void)?
    var onSilentWindow: (() -> Void)?
    var onBluetoothReset: (() -> Void)?
    
    private let analyzeDuration: TimeInterval = 5
    private var analyzeTimer: Timer?
    private var advCounter = 0
    
    private var manager: CBCentralManager?
    
    private let scanDuration: TimeInterval = 2
    private let scanInterval: TimeInterval = 0.5
    private var scanning = false
    private var scanTimer: Timer?
    
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        if case .poweredOn = manager?.state, !scanning {
            startScan()
        }
        analyzeTimer?.invalidate()
        analyzeTimer = Timer.scheduledTimer(timeInterval: analyzeDuration, target: self, selector: #selector(onAnalyzeTick), userInfo: nil, repeats: true)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn && !scanning {
            startScan()
        } else if central.state == .resetting {
            onBluetoothReset?()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        advCounter += 1
    }
    
    @objc private func onAnalyzeTick() {
        onADVCount?(advCounter)
        if advCounter == 0 {
            onSilentWindow?()
        }
        advCounter = 0
    }
    
    @objc private func startScan() {
        scanning = true
        scanTimer?.invalidate()
        manager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        scanTimer = Timer.scheduledTimer(timeInterval: scanDuration, target: self, selector: #selector(stopScan), userInfo: nil, repeats: false)
    }

    @objc private func stopScan() {
        manager?.stopScan()
        scanTimer = Timer.scheduledTimer(timeInterval: scanInterval, target: self, selector: #selector(startScan), userInfo: nil, repeats: false)
    }
}
