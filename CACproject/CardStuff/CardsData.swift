//
//  CardsData.swift
//  Congressional
//
//  Created by user on 10/28/17.
//  Copyright © 2017 Martinia. All rights reserved.
//

class CardsData{
    var category: String?
    var title: String?
    var content: String?
    var color: String?
    var postNum: String?
    
    init(category: String?, title: String?, content: String?, postNum: String?){
        self.category = category
        self.title = title
        self.content = content
        self.postNum = postNum
    }
}
