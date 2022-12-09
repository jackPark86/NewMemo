//
//  MemoData.swift
//  MyMemo
//
//  Created by icoinnet on 2022/10/27.
//

import UIKit
import CoreData

class MemoData {
    var memoIdx : Int? // 데이터 식별값
    var title : String? //메모 제목
    var contents : String? // 메모 내용
    var image: UIImage? //이미지
    var regdate : Date? //작성일
    
    //원본 MemoMO객체를 참조하기 위한 속성
    var objectID: NSManagedObjectID?
}
