import UIKit
import SnapKit

class ViewController: UIViewController {
    let scrollView = UIScrollView()
    let advInfoLabel = UILabel()
    let advLabel = UILabel()
    
    let silentWindowsInfoLabel = UILabel()
    let silentWindowsLabel = UILabel()
    
    let resetInfoLabel = UILabel()
    let resetsLabel = UILabel()
    
    private let historySize = 50
    private var silentWindowsHistory = [String]()
    private var resetHistory = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        let analyzer = BluetoothAnalyzer()
        analyzer.onADVCount = { count in
            self.advLabel.text = String(count)
        }
        analyzer.onSilentWindow = onSilentWindow
        analyzer.onBluetoothReset = onBluetoothReset
    }
    
    private func initUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(advInfoLabel)
        advInfoLabel.text = "ADV count in last 5s:"
        advInfoLabel.textColor = .black
        advInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().offset(20)
        }
        contentView.addSubview(advLabel)
        advLabel.text = "0"
        advLabel.textColor = .black
        advLabel.snp.makeConstraints { make in
            make.centerY.equalTo(advInfoLabel.snp.centerY)
            make.leading.equalTo(advInfoLabel.snp.trailing).offset(5)
        }
        
        contentView.addSubview(silentWindowsInfoLabel)
        silentWindowsInfoLabel.text = "Last windows without ADV detected (possible adapter crash):"
        silentWindowsInfoLabel.numberOfLines = 0
        silentWindowsInfoLabel.textColor = .black
        silentWindowsInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(advLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contentView.addSubview(silentWindowsLabel)
        silentWindowsLabel.text = "None"
        silentWindowsLabel.textColor = .black
        silentWindowsLabel.numberOfLines = 0
        silentWindowsLabel.snp.makeConstraints { make in
            make.top.equalTo(silentWindowsInfoLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(resetInfoLabel)
        resetInfoLabel.text = "Last bluetooth adapter resets:"
        resetInfoLabel.textColor = .black
        resetInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(silentWindowsLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        contentView.addSubview(resetsLabel)
        resetsLabel.text = "None"
        resetsLabel.textColor = .black
        resetsLabel.numberOfLines = 0
        resetsLabel.snp.makeConstraints { make in
            make.top.equalTo(resetInfoLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func onSilentWindow() {
        silentWindowsHistory.insert(currentTime(), at: 0)
        if (silentWindowsHistory.count > historySize) {
            silentWindowsHistory.removeLast()
        }
        silentWindowsLabel.text = silentWindowsHistory.joined(separator: "\n")
    }
    
    private func onBluetoothReset() {
        resetHistory.insert(currentTime(), at: 0)
        if (resetHistory.count > historySize) {
            resetHistory.removeLast()
        }
        resetsLabel.text = resetHistory.joined(separator: "\n")
    }
        
    private func currentTime() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter.string(from: currentDateTime)
    }
}
