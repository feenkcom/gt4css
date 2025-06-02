Class {
	#name : #GtCSSFilteredCodersViewModel,
	#superclass : #GtFilteredCodersViewModel,
	#category : #'Gt4CSS-Model'
}

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersViewModel >> gtViewFor: aView context: aDictionary [
	<gtView>
	| lspModel |
	lspModel := aDictionary at: #cssLSPModel ifAbsentPut: [ GtLSPCSSModel local ].
	^ aView explicit
		title: 'CSS strings';
		priority: 20;
		stencil: [ GtCSSStringStreamingCoderElement new
				showPackageAndClass: true;
				lspModel: lspModel;
				streamingCodersViewModel: self;
				yourself ]
]

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersViewModel >> newCoderViewModelFor: aCoderModel [
	^ aCoderModel asCoderViewModel expanded: false
]
