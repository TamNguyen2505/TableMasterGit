//
//  TopAlignedCollectionViewFlowLayout.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    //MARK: View cycle
    override init() {
        super.init()
        
        scrollDirection = .horizontal
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attributes = super.layoutAttributesForElements(in: rect), attributes.count > 1 else {return nil}
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        attributes.forEach{ (element) in

            guard element.representedElementCategory == .cell || element.representedElementCategory == .supplementaryView else {return}
            
            element.frame = element.frame.offsetBy(dx: 0, dy: -element.frame.minY + sectionInset.top)
            visibleLayoutAttributes.append(element)

        }

        return visibleLayoutAttributes

    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {return nil}
        
        attributes.frame = attributes.frame.offsetBy(dx: 0, dy: -attributes.frame.minY + sectionInset.top)
        
        return attributes
        
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {return nil}
        
        attributes.frame = attributes.frame.offsetBy(dx: 0, dy: -attributes.frame.minY + sectionInset.top)
        
        return attributes
        
    }

}
