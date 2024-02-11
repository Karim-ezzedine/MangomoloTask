//
//  HomeViewController.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit
import AVKit
import GoogleInteractiveMediaAds

class HomeViewController: BaseViewController {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var verticalMovieLabel: UILabel!
    @IBOutlet weak var verticalMovieCollectionView: UICollectionView!
    @IBOutlet weak var verticalMovieCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var horizontalMovieLabel: UILabel!
    @IBOutlet weak var horizontalMovieCollectionView: UICollectionView!
    @IBOutlet weak var horizontalMovieCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var subscriptionCheckBox: CheckBoxButton!
    
    //MARK: - Properties
    
    var player: AVPlayer?
    var imaAdsLoader: IMAAdsLoader?
    var adsManager: IMAAdsManager?
    
    //MARK: - View Model
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    //MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getMoviesaData()
    }
    
    override func setupInterface() {
        super.setupInterface()
        self.setupTitleLabel()
        self.setupCheckBox()
        self.setupVerticalMoviewCollectionView()
        self.setupHorizontalMoviewCollectionView()
        self.sink()
    }
    
    func setupTitleLabel() {
        self.verticalMovieLabel.text = "Sample Vertical"
        self.verticalMovieLabel.textColor = .customWhite
        self.verticalMovieLabel.font = .getBoldFont(size: 20)
        
        self.horizontalMovieLabel.text = "Sample Horizontal"
        self.horizontalMovieLabel.textColor = .customWhite
        self.horizontalMovieLabel.font = .getBoldFont(size: 20)
    }
    
    func setupCheckBox() {
        subscriptionCheckBox.isCheckBoxSelected = userDefaults.bool(forKey: UserDefaultsKeys.isSubscribed.rawValue)
        subscriptionCheckBox.text = "Subscribed to Mangomolo"
    }
    
    func setupVerticalMoviewCollectionView() {
        setupMovieCollectionView(collectionView: verticalMovieCollectionView, flowLayout: verticalMovieCollectionViewFlowLayout, itemWidthDevider: 2.6)
    }
    
    func setupHorizontalMoviewCollectionView() {
        setupMovieCollectionView(collectionView: horizontalMovieCollectionView, flowLayout: horizontalMovieCollectionViewFlowLayout, itemWidthDevider: 1.9)
    }
    
    func setupMovieCollectionView(collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout, itemWidthDevider: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 20

            flowLayout.itemSize = CGSize(
                width: collectionView.frame.width/itemWidthDevider,
                height: collectionView.frame.height
            )

            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: MovieImagCollectionViewCell.typeName, bundle: nil), forCellWithReuseIdentifier: MovieImagCollectionViewCell.typeName)
        }
    }
    
    //MARK: - Sink
    
    func sink() {
        self.viewModel.$verticalMoviesData
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return}
                self.verticalMovieCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        self.viewModel.$horizontalMoviesData
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return}
                self.horizontalMovieCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension HomeViewController {
    @IBAction func checkBoxAction(_ sender: Any) {
        subscriptionCheckBox.isCheckBoxSelected.toggle()
        userDefaults.set(subscriptionCheckBox.isCheckBoxSelected, forKey: UserDefaultsKeys.isSubscribed.rawValue)
    }
    
    func setupHlsMedia(hlsURL: URL) {
        let playerItem = AVPlayerItem(url: hlsURL)
        player = AVPlayer(playerItem: playerItem)
        self.platHlsMedia()
    }
    
    func setupIMAAdsLoader(adTagURL: String, hlsURL: URL) {
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        
        let adsRequest = IMAAdsRequest(
            adTagUrl: adTagURL,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: nil,
            userContext: nil
        )
        
        let playerItem = AVPlayerItem(url: hlsURL)
        player = AVPlayer(playerItem: playerItem)
        
        imaAdsLoader = IMAAdsLoader(settings: nil)
        imaAdsLoader?.delegate = self
        imaAdsLoader?.requestAds(with: adsRequest)
    }
    
    func platHlsMedia() {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) { [weak self] in
            self?.player?.play()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return collectionView == verticalMovieCollectionView ? self.viewModel.verticalMoviesData.count : self.viewModel.horizontalMoviesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieImagCollectionViewCell.typeName, for: indexPath as IndexPath) as! MovieImagCollectionViewCell
        
        let movie = collectionView == verticalMovieCollectionView ? self.viewModel.verticalMoviesData[indexPath.item] : self.viewModel.horizontalMoviesData[indexPath.item]
        
        cell.movie = movie
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let movie = collectionView == verticalMovieCollectionView ? self.viewModel.verticalMoviesData[indexPath.item] : self.viewModel.horizontalMoviesData[indexPath.item]
        
        guard let urlString = movie.hlsMediaUrl, let hlsURL = URL(string: urlString) else {
            self.showAlert(message: "This Movie is not available")
            return
        }
        
        if userDefaults.bool(forKey: UserDefaultsKeys.isSubscribed.rawValue) {
            self.setupHlsMedia(hlsURL: hlsURL)
        } else {
            guard let urlString = movie.imaAdsTag else { return }
            self.setupIMAAdsLoader(adTagURL: urlString, hlsURL: hlsURL)
            imaAdsLoader?.contentComplete()
        }
    }
}

//MARK: - IMA Ads

extension HomeViewController: IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {}
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {}
    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {}
    
    func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
        adsManager = adsLoadedData.adsManager
        adsManager?.delegate = self
        adsManager?.initialize(with: nil)
    }

    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        switch event.type {
        case IMAAdEventType.LOADED:
            adsManager.start()
        case IMAAdEventType.COMPLETE, IMAAdEventType.SKIPPED:
            self.platHlsMedia()
        default:
            break
        }
    }

    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        print("Ad loading failed: \(adErrorData.adError.message ?? "")")
        self.platHlsMedia()
    }
}
