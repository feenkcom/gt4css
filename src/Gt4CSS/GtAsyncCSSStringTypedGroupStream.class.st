Class {
	#name : #GtAsyncCSSStringTypedGroupStream,
	#superclass : #GtAsyncSearchTypedGroupStream,
	#category : 'Gt4CSS-Filter'
}

{ #category : #'gt - extensions' }
GtAsyncCSSStringTypedGroupStream >> gtItemsFor: aView [
	<gtView>
	^ aView forward
		title: 'Live' translated;
		priority: 10;
		object: [ self ];
		view: #gtItemsFor:context:
]

{ #category : #'gt - extensions' }
GtAsyncCSSStringTypedGroupStream >> gtItemsFor: aView context: aContext [
	<gtView>
	| lspModel |
	lspModel := aContext at: #cssLSPModel ifAbsentPut: [ GtLSPCSSModel local ].
	^ aView explicit
		title: 'CSS strings';
		priority: 20;
		stencil: [ GtCSSStringStreamingCoderElement new
				lspModel: lspModel;
				showPackageAndClass: filter cssShowBehavior;
				streamingCodersViewModel: (GtCSSFilteredCodersViewModel new
						streamingCodersModel: (GtCSSFilteredCodersModel forFilter: filter)) ]
]
