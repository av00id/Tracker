//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

class TrackersViewController: UIViewController {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.text = "Трекеры"
        return label
    }()
    
    private lazy var addTrackersButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 18,
                    weight: .bold
                )
            )!,
            target: self, action: #selector(didTapAddButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlack
        button.backgroundColor = .ypWhite
        return button
    }()
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.backgroundColor = .ypWhite
        picker.tintColor = .ypBlue
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar = Calendar(identifier: .iso8601)
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Поиск"
        view.searchBarStyle = .minimal
        view.delegate = self
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        
        collectionView.register(TrackerCategoryLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collectionView
    }()
    
   private let notFoundStack = NotFoundStack(label: "Что будем отслеживать?")
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlue
        return button
    }()
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var categories = [TrackerCategory]()
    private var searchText = "" {
        didSet {
            try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        }
    }
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date.from(date: Date())!
    private let params = GeometricParams(cellCount: 2,
                                         leftInset: 16,
                                         rightInset: 16,
                                         topInset: 8,
                                         bottomInset: 16,
                                         height: 148,
                                         cellSpacing: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        addContent()
        addConstraints()
        
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        
        try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        try? trackerRecordStore.loadCompletedTrackers(by: currentDate)
        
        checkNumberOfTrackers()
    }
    
    private func addContent() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view.addSubview(addTrackersButton)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(notFoundStack)
        view.addSubview(filterButton)
    
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            addTrackersButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            addTrackersButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: addTrackersButton.bottomAnchor, constant: 13),
            
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -8),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            notFoundStack.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            notFoundStack.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = Date.from(date: sender.date)!
        
        do {
            try trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
            try trackerRecordStore.loadCompletedTrackers(by: currentDate)
        } catch {}
        
        
        collectionView.reloadData()
    }
    
    
    @objc func didTapAddButton() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addTrackerViewController)
        present(navigationController, animated: true)
    }
    
    private func checkNumberOfTrackers() {
        if trackerStore.numberOfTrackers == 0 {
            notFoundStack.isHidden = false
            filterButton.isHidden = true
        } else {
            notFoundStack.isHidden = true
            filterButton.isHidden = false
        }
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numbersOfRowInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
            )as? TrackerCell,
              let tracker = trackerStore.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }

        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        trackerCell.configure(with: tracker, days: tracker.completedDaysCount, isCompleted: isCompleted)
        trackerCell.delegate = self
        
        return trackerCell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let avaliableSpace = collectionView.frame.width - params.paddingWidth
        let cellWidth = avaliableSpace / params.cellCount
        return CGSize(width: cellWidth, height: params.height)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectiobViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerCategoryLabel
        else { return UICollectionReusableView() }
        
        guard let label = trackerStore.headerLabelInSection(indexPath.section) else { return UICollectionReusableView() }
        view.configure(with: label)
        
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchText = ""
        collectionView.reloadData()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func didTapCompleteButton(of cell: TrackerCell, with tracker: Tracker) {
       if let recordToRemove = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            try? trackerRecordStore.remove(recordToRemove)
            cell.toggleCompletedButton(to: false)
            cell.decreaseCount()
        } else {
            let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            try? trackerRecordStore.add(trackerRecord)
            cell.toggleCompletedButton(to: true)
            cell.increaseCount()
        }
    }
}

extension TrackersViewController: AddTrackerViewControllerDelegate {
    
    func didSelectTracker(with type: AddTrackerViewController.TrackerType) {
        dismiss(animated: true)
        let trackerFormViewController = TrackerFormViewController(type: type)
        trackerFormViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerFormViewController)
        navigationController.isModalInPresentation = true
        present(navigationController, animated: true)
    }
}

extension TrackersViewController: TrackerFormViewControllerDelegate {
    func didTapConfirmButton(category: TrackerCategory, trackerToAdd: Tracker) {
        dismiss(animated: true)
        try? trackerStore.addTracker(trackerToAdd, with: category)
    }
    
    func didTapCancelButton() {
        collectionView.reloadData()
        dismiss(animated: true)
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func didUpdate() {
        checkNumberOfTrackers()
        collectionView.reloadData()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords(_ records: Set<TrackerRecord>) {
        completedTrackers = records
    }
}
