//
//  MemoReadVC.swift
//  MyMemo
//
//  Created by icoinnet on 2022/10/27.
//

import UIKit

class MemoReadVC: UIViewController {

    //콘텐츠 데이터를 저장하는 변수
    var param: MemoData?
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. 제목과 내용, 이미지 출력
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        //2. 날짜 포맷 변호나
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        //3 내비게이션 타이틀에 날짜를 표시
        self.navigationItem.title = dateString

    }
    

}
