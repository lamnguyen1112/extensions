//
//  UITableView+Extension.swift
//  Template
//
//  Created by Lam Nguyen on 4/24/22.
//

#if !os(macOS)
    import UIKit

    public extension UITableView {
        func layoutSizeFittingHeaderView(_ width: CGFloat? = nil) {
            guard let viewFitting = tableHeaderView else { return }

            let fitWidth = width ?? frame.width

            viewFitting.translatesAutoresizingMaskIntoConstraints = false
            // [add subviews and their constraints to view]
            let widthConstraint = NSLayoutConstraint(item: viewFitting, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fitWidth)
            widthConstraint.isActive = true

            viewFitting.addConstraint(widthConstraint)
            viewFitting.setNeedsLayout()
            viewFitting.layoutIfNeeded()
            let fittingHeight = viewFitting.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            viewFitting.removeConstraint(widthConstraint)
            widthConstraint.isActive = false

            viewFitting.frame = CGRect(x: 0, y: 0, width: fitWidth, height: fittingHeight)
            viewFitting.translatesAutoresizingMaskIntoConstraints = true

            tableHeaderView = viewFitting
        }

        func layoutSizeFittingFooterView(_ width: CGFloat? = nil) {
            guard let viewFitting = tableFooterView else { return }

            let fitWidth = width ?? frame.width

            viewFitting.translatesAutoresizingMaskIntoConstraints = false
            // [add subviews and their constraints to view]
            let widthConstraint = NSLayoutConstraint(item: viewFitting, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fitWidth)
            widthConstraint.isActive = true

            viewFitting.addConstraint(widthConstraint)
            viewFitting.setNeedsLayout()
            viewFitting.layoutIfNeeded()
            let fittingHeight = viewFitting.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            viewFitting.removeConstraint(widthConstraint)
            widthConstraint.isActive = false

            viewFitting.frame = CGRect(x: 0, y: 0, width: fitWidth, height: fittingHeight)
            viewFitting.translatesAutoresizingMaskIntoConstraints = true

            tableFooterView = viewFitting
        }

        func setTableHeaderViewLayoutSizeFitting(_ headerView: UIView) {
            tableHeaderView = headerView
            layoutSizeFittingHeaderView()
        }

        func setTableFooterViewLayoutSizeFitting(_ footerView: UIView) {
            tableFooterView = footerView
            layoutSizeFittingFooterView()
        }

        func makeHeaderLeastNonzeroHeight() {
            let tempHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: CGFloat.leastNonzeroMagnitude))
            tableHeaderView = tempHeaderView
        }

        func makeFooterLeastNonzeroHeight() {
            let tempHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: CGFloat.leastNonzeroMagnitude))
            tableFooterView = tempHeaderView
        }

        func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
            return indexPath.row >= 0 && indexPath.section >= 0 && indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
        }

        func scrollToLastRow(animated: Bool = true, atScrollPosition: UITableView.ScrollPosition = .bottom) {
            let section = numberOfSections - 1
            guard section >= 0 else { return }
            let row = numberOfRows(inSection: section) - 1
            guard row >= 0, isValidIndexPath(IndexPath(row: row, section: section)) else { return }

            scrollToRow(at: IndexPath(row: row, section: section), at: atScrollPosition, animated: animated)
        }

        func scrollToCell(_ toCell: UITableViewCell?, animated: Bool = true, atScrollPosition: UITableView.ScrollPosition = .bottom) {
            guard let cell = toCell else { return }
            guard let indexPath = indexPath(for: cell), isValidIndexPath(indexPath) else { return }

            scrollToRow(at: indexPath, at: atScrollPosition, animated: animated)
        }

        func isLastIndexPath(_ indexPath: IndexPath) -> Bool {
            return (indexPath.section == numberOfSections - 1) && (indexPath.row == numberOfRows(inSection: indexPath.section) - 1)
        }

        func setSeparatorNoneForNoCells() {
            let footerV = UIView()
            footerV.backgroundColor = backgroundColor ?? UIColor.white
            tableFooterView = footerV
        }

        func reloadData(_ completion: @escaping () -> Void) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            reloadData()
            CATransaction.commit()
        }

        func reloadDataWithResetOffset() {
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.allowAnimatedContent, animations: { [weak self] in
                self?.contentOffset = CGPoint.zero
            }) { [weak self] _ in
                self?.reloadData()
            }
        }

        func register<T: UITableViewCell>(_ cell: T.Type) {
            register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
        }

        func dequeue<T: UITableViewCell>(as cell: T.Type, for indexPath: IndexPath? = nil) -> T? {
            if let idx = indexPath {
                return dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: idx) as? T
            } else {
                return dequeueReusableCell(withIdentifier: cell.reuseIdentifier) as? T
            }
        }

        func deselectSelectedRows(animated: Bool = true) {
            indexPathsForSelectedRows?.forEach {
                deselectRow(at: $0, animated: animated)
            }
        }

        func batchUpdates(_ updates: (() -> Swift.Void)?, completion: ((Bool) -> Swift.Void)? = nil) {
            if #available(iOS 11, *) {
                performBatchUpdates(updates, completion: completion)
            } else {
                guard let updateBlock = updates else {
                    completion?(false)
                    return
                }
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    if let completionBlock = completion {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            if Thread.isMainThread {
                                completionBlock(true)
                            } else {
                                DispatchQueue.main.async {
                                    completionBlock(true)
                                }
                            }
                        }
                    }
                }
                beginUpdates()
                updateBlock()
                endUpdates()
                CATransaction.commit()
            }
        }
    }

    public extension UITableViewCell {
        static var reuseIdentifier: String { return String(describing: self) }

        var parentTableView: UITableView? {
            var parentView: UIView? = superview
            while parentView != nil, (parentView as? UITableView) == nil {
                parentView = parentView?.superview
            }

            return parentView as? UITableView
        }

        func setSeparatorFullWidth() {
            preservesSuperviewLayoutMargins = false
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero
        }

        func setSeparatorInsets(_ edgeInsets: UIEdgeInsets) {
            preservesSuperviewLayoutMargins = false
            separatorInset = edgeInsets
            layoutMargins = UIEdgeInsets.zero
        }

        func setSeparatorInsetsEdges(left: CGFloat, right: CGFloat) {
            var edgeInsets = UIEdgeInsets.zero
            edgeInsets.left = left
            edgeInsets.right = right

            preservesSuperviewLayoutMargins = false
            separatorInset = edgeInsets
            layoutMargins = UIEdgeInsets.zero
        }

        class func registerNib(to tableView: UITableView) {
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        }

        class func registerClass(to tableView: UITableView) {
            tableView.register(self, forCellReuseIdentifier: reuseIdentifier)
        }

        class func dequeue(from tableView: UITableView, for indexPath: IndexPath? = nil) -> Self {
            func _dequeue<T>(from tableView: UITableView, for indexPath: IndexPath?) -> T {
                if let idx = indexPath {
                    return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: idx) as! T
                } else {
                    return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! T
                }
            }
            return _dequeue(from: tableView, for: indexPath)
        }
    }
#endif
