//
//  UICollectionView++.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

public protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

public extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var kind: String {
        return String(describing: self) + "kind"
    }
}

extension UITableViewCell: ReuseIdentifiable {}
extension UICollectionReusableView: ReuseIdentifiable {}

extension UICollectionView {
    public func register(cells: UICollectionViewCell.Type...) {
        cells.forEach { self.register($0, forCellWithReuseIdentifier: $0.reuseIdentifier) }
    }
    
    public func register(headers: UICollectionReusableView.Type...) {
        headers.forEach { header in
            self.register(header,
                          forSupplementaryViewOfKind: header.kind,
                          withReuseIdentifier: header.reuseIdentifier)
        }
    }
    
    public func register(footer: UICollectionReusableView.Type) {
        self.register(footer,
                      forSupplementaryViewOfKind: footer.kind,
                      withReuseIdentifier: footer.reuseIdentifier)
    }
    
    public func getHeaderFooter<T: UICollectionReusableView>(
        for indexPath: IndexPath
    ) -> T? {
        guard let view = self.dequeueReusableSupplementaryView(
            ofKind: T.kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            return nil
        }
        return view
    }
    
    public func dequeueCell<T: UICollectionViewCell>(
        for indexPath: IndexPath
    ) -> T? {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            return nil
        }
        return cell
    }
    
    public func headerView<T: UICollectionReusableView>(ofType type: T.Type,
                                                        at indexPath: IndexPath) -> T? {
        return self.supplementaryView(forElementKind: T.kind, at: indexPath) as? T
    }
}
