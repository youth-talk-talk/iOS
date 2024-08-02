//
//  SummaryTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit

class SummaryTableViewCell: BaseTableViewCell {
    
    let testLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(testLabel)
                .grow(1)
                .marginHorizontal(0)
        }
    }

    override func configureView() {
        
        testLabel.designed(text: "", fontType: .g14Bold, textColor: .black)
    }
    
    func test(_ data: DetailPolicyEntity.PolicySummary) {
        
        var result = ""
        
        if let applyTerm = data.applyTerm {
            
            result += applyTerm
        }
        
        if let introduction = data.introduction {
            
            result += introduction
        }
        
        testLabel.designed(text: result, fontType: .g14Bold, textColor: .black)
        
        testLabel.numberOfLines = 0
        
        flexView.flex.layout(mode: .adjustHeight)
    }
}
