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
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {return .zero}
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView.bounds.size.width,
                                height: collectionView.bounds.size.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach { (layoutAttributes) in
            
            let itemOffset = layoutAttributes.frame.origin.x
            
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                
                offsetAdjustment = itemOffset - horizontalOffset
                
            }
            
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        
    }
    
}
