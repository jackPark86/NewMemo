//
//  CSLogButton.swift
//  MyMemo
//
//  Created by icoinnet on 2022/11/09.
//

import UIKit

public enum CSLogType : Int  {
    case basic
    case title
    case tag
}

public class CSLogButton: UIButton {

    public var logType : CSLogType = .basic

    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //버튼에 스타일 적용
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal)
        self.tintColor = .white
        
        //버튼의 클릭 이벤트에 logging(_:) 메소드를 연결
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    //로그를 출력하는 액션 메소드
    @objc  func logging(_ sender: UIButton){
        switch self.logType {
        case .basic: //단순히 로그만 출력함
            NSLog("버튼이 클릭되었습니다.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는"
            NSLog("\(btnTitle) 버튼이 클릭되었습니다.")
        case .tag:
            NSLog("\(sender.tag) 버튼이 클릭되었습니다.")
        }
        
    }
}
