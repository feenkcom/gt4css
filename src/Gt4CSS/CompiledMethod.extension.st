Extension { #name : #CompiledMethod }

{ #category : #'*Gt4CSS' }
CompiledMethod >> gtCSSMethodCoder [
	<gtMethodCoder: 10>
	^ (self pragmaAt: #cssString) ifNotNil: [ GtCSSCoderModel ]
]

{ #category : #'*Gt4CSS' }
CompiledMethod >> gtCSSStringFor: aView [
	<gtView>
	(self pragmas anySatisfy: [ :each | each selector = #cssString ])
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'CSS';
		object: [ GtCSSCoderModel new forMethod: self ];
		view: #gtLiveFor:context:
]
