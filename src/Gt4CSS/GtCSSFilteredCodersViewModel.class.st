Class {
	#name : #GtCSSFilteredCodersViewModel,
	#superclass : #GtFilteredCodersViewModel,
	#category : 'Gt4CSS-Model'
}

{ #category : #views }
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

{ #category : #'instance creation' }
GtCSSFilteredCodersViewModel >> newCoderViewModelFor: aCoderModel [
	^ aCoderModel asCoderViewModel
		highlighter: self highlighter;
		expanded: false;
		yourself
]
