//
//  TagViews+Rx.swift
//  Tags
//
//  Created by iamchiwon on 2018. 9. 11..
//  Copyright © 2018년 iamchiwon. All rights reserved.
//

import UIKit
import Tags
import RxSwift
import RxCocoa

extension Reactive where Base: TagsView {

    public func touchAction() -> Observable<TagButton> {
        return RxTagsViewProxy.proxy(for: base).touchActionSubject.asObservable()
    }

    public func lastTagAction() -> Observable<TagButton> {
        return RxTagsViewProxy.proxy(for: base).lastTagActionSubject.asObservable()
    }

    public func changeHeight() -> Observable<CGFloat> {
        return RxTagsViewProxy.proxy(for: base).changeHeightSubject.asObservable()
    }

}

class RxTagsViewProxy: DelegateProxy<TagsView, TagsDelegate>, DelegateProxyType, TagsDelegate {

    public init(tagsView: TagsView) {
        super.init(parentObject: tagsView, delegateProxy: RxTagsViewProxy.self)
    }

    // MARK: - DelegateProxyType

    public static func registerKnownImplementations() {
        self.register { RxTagsViewProxy(tagsView: $0) }
    }

    static func currentDelegate(for object: TagsView) -> TagsDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: TagsDelegate?, to object: TagsView) {
        object.delegate = delegate
    }

    // MARK: - Proxy Subjects

    internal lazy var touchActionSubject = PublishSubject<TagButton>()
    internal lazy var lastTagActionSubject = PublishSubject<TagButton>()
    internal lazy var changeHeightSubject = PublishSubject<CGFloat>()

    // MARK: - TagsDelegate

    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        touchActionSubject.onNext(tagButton)
    }

    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
        lastTagActionSubject.onNext(tagButton)
    }

    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
        changeHeightSubject.onNext(height)
    }

    // MARK: - Completed

    deinit {
        self.touchActionSubject.onCompleted()
        self.lastTagActionSubject.onCompleted()
        self.changeHeightSubject.onCompleted()
    }
}
