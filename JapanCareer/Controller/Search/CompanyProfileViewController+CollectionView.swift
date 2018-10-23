//
//  CompanyProfileViewController+CollectionViewMethods.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/14.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit


extension CompanyProfileViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomNavBarCell
        switch indexPath.item {
        case 0:
            cell.titleLabel.text = "About"
        case 1:
            cell.titleLabel.text = "Job"
        case 2:
            cell.titleLabel.text = "Other"
        default:
            cell.titleLabel.text = "Title"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tableView.bounds.width / 3, height: 44)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != currentTabNumber {
            currentTabNumber = indexPath.item
            highlightLeftAnchor?.constant = CGFloat(indexPath.item) * tableView.bounds.width / 3

            UIView.animate(withDuration: 0.25, animations: {
                self.tableView.layoutIfNeeded()
                
            }) { (finished) in
                var indexPathes = [IndexPath]()
                let numberOfContents = self.currentDescriptionViewData.count
                for i in 0..<numberOfContents {
                    indexPathes.append(IndexPath(row: i, section: 1))
                }
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        let contentOffset = self.tableView.contentOffset
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(contentOffset, animated: false)
                    }
                }
            }
        }
    }

    
}
