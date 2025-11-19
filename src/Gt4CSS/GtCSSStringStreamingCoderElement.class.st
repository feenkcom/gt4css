Class {
	#name : #GtCSSStringStreamingCoderElement,
	#superclass : #BrVerticalPane,
	#traits : 'TGtWithStreamingCodersViewModel',
	#classTraits : 'TGtWithStreamingCodersViewModel classTrait',
	#instVars : [
		'list',
		'listItemsProvider',
		'lspModel',
		'showPackageAndClass'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSStringStreamingCoderElement >> initialize [
	super initialize.
	showPackageAndClass := false.
	self matchParent.
	self beInSeparateCompositionLayer.
	listItemsProvider := BrStreamItemsProvider new stream: AsyncEmptyStream new.
	list := BrSimpleList new
			itemType: [ :anItemTypeFactory :anItemObject | anItemObject elementClass ];
			itemStencil: [ :anElementClass | anElementClass new vFitContentLimited id: GtSourceCoderId ];
			itemId: [ :eachCoderViewModel | eachCoderViewModel coder id ];
			itemDataBinder: [ :aCoderElement :aCoderViewModel :anItemIndex | 
				aCoderElement
					lspModel: lspModel;
					id: (GtSourceCoderId indexed: anItemIndex);
					textualCoderViewModel: aCoderViewModel;
					showPackageAndClass: showPackageAndClass ];
			itemsProvider: listItemsProvider.
	list matchParent.
	self addChild: list
]

{ #category : #accessing }
GtCSSStringStreamingCoderElement >> lspModel [
	^ lspModel
]

{ #category : #accessing }
GtCSSStringStreamingCoderElement >> lspModel: anObject [
	lspModel := anObject
]

{ #category : #'api - streaming coders view model' }
GtCSSStringStreamingCoderElement >> onStreamingCodersChanged: anAnnouncement [
	listItemsProvider stream: streamingCodersViewModel coderViewModelsStream
]

{ #category : #'api - streaming coders view model' }
GtCSSStringStreamingCoderElement >> onStreamingCodersViewModelChanged [
	listItemsProvider stream: streamingCodersViewModel coderViewModelsStream
]

{ #category : #accessing }
GtCSSStringStreamingCoderElement >> showPackageAndClass [
	^ showPackageAndClass
]

{ #category : #accessing }
GtCSSStringStreamingCoderElement >> showPackageAndClass: anObject [
	showPackageAndClass := anObject
]

{ #category : #'api - streaming coders view model' }
GtCSSStringStreamingCoderElement >> subscribeToStreamingCodersViewModel [
	streamingCodersViewModel
		when: GtStreamingCodersViewModelStreamChanged
		send: #onStreamingCodersChanged:
		to: self
]
