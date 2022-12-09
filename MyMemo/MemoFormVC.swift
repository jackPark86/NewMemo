//
//  MemoFormVC.swift
//  MyMemo
//
//  Created by icoinnet on 2022/10/27.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    
    var subject: String!
    lazy var dao = MemoDAO() //추가코드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self
        
        //배경 이미지 설정
        let bgImage = UIImage(named: "memo-background.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        //텍스트 뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        //줄 간격
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle: style])
        self.contents.text = ""
    }
    

    
    @IBAction func save(_ sender: Any) {
        //경고창에 사용될 콘텐츠 뷰 컨트롤러 구성
        
        let iconImage = UIImage(named: "warning-icon-60")!

        //1. 복합적인 레이아웃을 구현할 컨테이너 뷰
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: iconImage.size.height + 50))
        
        //2. 상단 레이블 정의
        /*let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = UIFont.systemFont(ofSize: 15)
        topTitle.textColor = .black
        topTitle.text = "58개 숙소"*/
        
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: iconImage.size.width, height: iconImage.size.height))
        img.center.x = containerView.frame.width / 2
        img.image = iconImage
        
        let subTitle = UILabel(frame: CGRect(x: 0, y: iconImage.size.height + 18, width: 200, height: 18))
        subTitle.numberOfLines = 1
        subTitle.textAlignment = .center
        subTitle.font = UIFont.systemFont(ofSize: 12)
        subTitle.textColor = .black
        subTitle.text = "경고창 커스텀"
        
        //4. 상하단 레이블을 컨테이너 뷰에 추가한다
        containerView.addSubview(img)
        containerView.addSubview(subTitle)
        
        let alertV = UIViewController()
        alertV.view = containerView
        alertV.preferredContentSize = containerView.frame.size
        
        /*let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60")
        alertV.view = UIImageView(image:  iconImage)
        alertV.preferredContentSize = iconImage?.size ?? CGSize.zero*/
    
        
        //내용을 입력하지 않았을 경우, 경고한다
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: true)
            return
        }
        
      // MemoData 객체를 생성하고, 데이터를 담는다.
        let data = MemoData()
        
        data.title  = self.subject //제목
        data.contents = self.contents.text //내용
        data.image = self.preview.image //이미지
        data.regdate = Date() //작성시간
        
        //앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData 객체를 추가한다.
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.memolist.append(data)
        
        //코어 데이터에 메모 데이터를 추가한다
        self.dao.insert(data)
        
        //작성폼 화면을 종료하고, 이전 화면으로 되돌아간다.
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //카메라 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func pick(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "이미지를 가져올 곳을 선택해주세요!", preferredStyle: .actionSheet)
        
        //이미지 피커 인스턴스를 생성한다
        let picker = UIImagePickerController()
        
        picker.delegate = self //이미지 피커 컨트롤러 인스턴스의 델리게이트 속성을 현재의 뷰 컨트롤러 인스턴스로 설정한다.
        picker.allowsEditing =  true //이미지 피커 컨트롤러의 이미지 편집을 허용한다.
        
        alert.addAction(UIAlertAction(title: "카메라", style: .default){ (_) in
            picker.sourceType = .camera
            self.present(picker, animated: false)
        })
        alert.addAction(UIAlertAction(title: "저장앨범", style: .default){ (_) in
            self.present(picker, animated: false)
        
        })
        
        self.present(alert, animated: true)
        
        //이미지 피커 화면을 표시한다
        //self.present(picker, animated: false)
    }
    
    //사용자가 이미지를 선택하면 자동으로 이 메소드가 호출된다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //선택된 이미즈를 미리보기에 출력한다.
        self.preview.image = info[.editedImage] as? UIImage
        
        //이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
        
    }
    
    //사용자가 텍스트 뷰에 뭔가를 입력하면 자동으로. 이 메소드가 호출된다
    func textViewDidChange(_ textView: UITextView) {
        //내용의 최대 15자리까지 읽어 subject 변수에 저장한다.
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15  : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        //내비게이션 타이틀에 표시한다.
        self.navigationItem.title = self.subject
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        
        
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts){
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
    
}
