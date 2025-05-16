Class {
	#name : #GtAsyncCSSStringTypedGroupStream,
	#superclass : #GtAsyncSearchTypedGroupStream,
	#category : #'Gt4CSS-Filter'
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
		stencil: [ | list |
			list := BrSimpleList new
					matchParent;
					stream: (self asyncSimilarCopy
							collect: [ :each | 
								(GtCSSCoderModel new
									forMethod: each method;
									highlighter: self highlighter;
									yourself) asCoderViewModel expanded: false ]);
					itemType: [ :factory :each | each elementClass ];
					itemStencil: [ :class | 
						class new
							vFitContentLimited;
							lspModel: lspModel;
							yourself ];
					itemDataBinder: [ :eachCoderElement :eachCoderViewModel | 
						eachCoderElement
							coderViewModel: eachCoderViewModel;
							showPackageAndClass: true ] ]
]
