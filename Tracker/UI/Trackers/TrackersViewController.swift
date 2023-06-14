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
        label.text = L10n.Main.title
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
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        view.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        view.register(
            TrackerCategoryLabel.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        return view
    }()
    
    private let notFoundStack = NotFoundStack(
        label: "Что будем отслеживать?",
        image: UIImage(named: "tracker_placeholder"))
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.filters, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlue
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let analyticService = AnalyticService()
    
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
    private var editingTracker: Tracker?
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticService.report(event: AnalyticEventNames.open, params: ["screen": AnalyticScreenNames.trackers,
                                                                        "item": AnalyticItemNames.none])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticService.report(event: AnalyticEventNames.close, params: ["screen": AnalyticScreenNames.trackers,
                                                                         "item": AnalyticItemNames.none])
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
        analyticService.report(event: AnalyticEventNames.click, params: ["screen": AnalyticScreenNames.trackers,
                                                                         "item": AnalyticItemNames.addTrack])
        
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc func filterButtonTapped() {
        analyticService.report(event: AnalyticEventNames.open, params: ["screen": AnalyticScreenNames.trackers,
                                                                        "item": AnalyticItemNames.filter])
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
    
    private func presentFormController(
        with data: Tracker.Data? = nil,
        of trackerType: AddTrackerViewController.TrackerType,
        formType: TrackerFormViewController.FormType
    ) {
        let trackerFormViewController = TrackerFormViewController(
            formType: formType,
            trackerType: trackerType,
            data: data
        )
        trackerFormViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerFormViewController)
        navigationController.isModalInPresentation = true
        present(navigationController, animated: true)
    }
    
    private func onTogglePin(_ tracker: Tracker) {
        try? trackerStore.togglePin(for: tracker)
    }
    private func onEdit(_ tracker: Tracker) {
        self.analyticService.report(event: AnalyticEventNames.open,
                                    params: ["screen": AnalyticScreenNames.trackers,
                                             "item": AnalyticItemNames.edit])
        let type: AddTrackerViewController.TrackerType = tracker.schedule != nil ? .habit : .irregularEvent
        editingTracker = tracker
        presentFormController(with: tracker.data, of: type, formType: .edit)
    }
    private func onDelete(_ tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: "Уверены, что хотите удалить трекер?",
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let deleteAction = UIAlertAction(title: " Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.analyticService.report(event: AnalyticEventNames.open,
                                        params: ["screen": AnalyticScreenNames.trackers,
                                                 "item": AnalyticItemNames.delete
                                                ])
            try? self.trackerStore.deleteTracker(tracker)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
        guard
            let trackerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        )as? TrackerCell,
              let tracker = trackerStore.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        let interaction = UIContextMenuInteraction(delegate: self)
        trackerCell.configure(
            with: tracker,
            days: tracker.completedDaysCount,
            isCompleted: isCompleted,
            interaction: interaction
        )
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
        viewForSupplementaryElementOfKind kind: String,
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
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
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
        presentFormController(of: type, formType: .add)
    }
}

extension TrackersViewController: TrackerFormViewControllerDelegate {
    func didAddTracker(category: TrackerCategory, trackerToAdd: Tracker) {
        dismiss(animated: true)
        try? trackerStore.addTracker(trackerToAdd, with: category)
    }
    
    func didUpdateTracker(with data: Tracker.Data) {
        guard let editingTracker else { return }
        dismiss(animated: true)
        try? trackerStore.updateTracker(editingTracker, with: data)
        self.editingTracker = nil
    }
    
    func didTapCancelButton() {
        collectionView.reloadData()
        editingTracker = nil
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

extension TrackersViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        guard
            let location = interaction.view?.convert(location, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: location),
            let tracker = trackerStore.tracker(at: indexPath)
        else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            UIMenu(children: [
                UIAction(title: tracker.isPinned ? "Открепить" : "Закрепить") { [weak self] _ in
                    self?.onTogglePin(tracker)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.onEdit(tracker)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.onDelete(tracker)
                    
                    
                }
            ])
        })
    }
}



