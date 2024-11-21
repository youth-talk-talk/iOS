//
//  ImagePicker.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/20/24.
//

import UIKit
import Photos
import BSImagePicker

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(assets: [PHAsset]?, deletedAssets: [PHAsset]?)
}

public protocol ImagePickerProtocol {
    func present()
    func didAssetOrderChanged(asset: PHAsset?)
    func evenAssetsCount() -> Int
}

open class ImagePicker: ImagePickerProtocol {
    private let imageManager = PHImageManager.default()
    
    private var evenAssets = [PHAsset]()
    private var addedAssets = [PHAsset]()
    private var deletedAssets = [PHAsset]()
    
    private var imagePicker = ImagePickerController()
    private weak var delegate: ImagePickerDelegate?
    private var presentationController: UIViewController?
    private var width: CGFloat?
    
    private lazy var cancelLabel = UILabel().then({
        $0.text = "취소"
        $0.textColor = .systemBlue
    })
    
    public init(presentationController: UIViewController,
                delegate: ImagePickerDelegate,
                width: CGFloat?) {
        
        self.presentationController = presentationController
        self.delegate = delegate
        self.width = width
    }
    
    public func didAssetOrderChanged(asset: PHAsset?) {
        self.evenAssets.removeAll(where: { $0 == asset! })
        self.imagePicker.deselect(asset: asset!)
    }
    
    public func present() {
        guard let presentationController = presentationController else {
            return
        }
        
        if evenAssets.isEmpty {
            imagePicker = ImagePickerController(selectedAssets: evenAssets)
        }
        
        imagePicker.doneButtonTitle = "완료"
        imagePicker.cancelButton = UIBarButtonItem(title: "취소", style: .done, target: nil, action: nil)
        imagePicker.settings.theme.selectionStyle = .checked
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.list.cellsPerRow = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.compact, .regular): // iPhone5-6 portrait
                return 4
            case (.compact, .compact): // iPhone5-6 landscape
                return 4
            case (.regular, .regular): // iPad portrait/landscape
                return 5
            default:
                return 4
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.imagePicker.modalPresentationStyle = .fullScreen
        }
        
        imagePicker.settings.fetch.album.fetchResults = [
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: .none),
            PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: .none),
        ]
        
        presentationController.presentImagePicker(imagePicker, select: { _ in
        }, deselect: { _ in
        }, cancel: { _ in
        }, finish: { [weak self] (assets) in
            guard let selfRef = self else { return }
            DispatchQueue.global().async {
                assets.forEach { asset in
                    if !selfRef.evenAssets.contains(asset) {
                        selfRef.evenAssets.append(asset)
                    }
                }
                DispatchQueue.main.async {
                    selfRef.deletedAssets = selfRef.evenAssets.filter { !assets.contains($0) }
                    selfRef.evenAssets = selfRef.evenAssets.filter { assets.contains($0) }
                    selfRef.delegate?.didSelect(assets: selfRef.evenAssets, deletedAssets: selfRef.deletedAssets)
                }
            }
        }, completion: { [weak self] in
            guard let selfRef = self else { return }
            selfRef.deletedAssets.removeAll()
        })
    }
    
    public func evenAssetsCount() -> Int {
        evenAssets.count
    }
}
