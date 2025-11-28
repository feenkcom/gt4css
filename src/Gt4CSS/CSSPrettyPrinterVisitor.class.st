Class {
	#name : #CSSPrettyPrinterVisitor,
	#superclass : #Object,
	#traits : 'TCSSProgramNodeVisitor',
	#classTraits : 'TCSSProgramNodeVisitor classTrait',
	#instVars : [
		'stream'
	],
	#category : 'Gt4CSS-Model'
}

{ #category : #'as yet unclassified' }
CSSPrettyPrinterVisitor >> contents [
	^stream contents
]

{ #category : #'as yet unclassified' }
CSSPrettyPrinterVisitor >> initialize [
	super initialize.
	stream := String new writeStream
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitDeclaration: aDeclaration [
	stream
		tab;
		nextPutAll: aDeclaration name value.
	stream nextPutAll: ': '.
	aDeclaration star ifNotNil: [self error: 'not yet implemented'].
	aDeclaration values do: [:e | self accept: e] separatedBy: [stream space]
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitDelimiter: aDelimiter [
	stream nextPutAll: aDelimiter value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitDimension: aDimension [
	stream nextPutAll: aDimension value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitFunction: aFunction [
	stream nextPutAll: aFunction name value.
	aFunction items do: [:e | self accept: e].
	stream nextPutAll: ')'
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitHash: aHash [
	stream nextPutAll: aHash name value
]

{ #category : #'as yet unclassified' }
CSSPrettyPrinterVisitor >> visitIdentifier: anIdentifier [
	stream nextPutAll: anIdentifier name value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitNumber: aNumber [
	stream nextPutAll: aNumber value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitPercentage: aPercentage [
	stream nextPutAll: aPercentage value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitRuleset: aRuleset [
	| col |
	col := aRuleset selectorParts.
	col doWithIndex: 
			[:e :i |
			i > 1
				ifTrue: 
					[(col at: i - 1) stopPosition + 1 = e startPosition ifFalse: [stream space]].
			self accept: e].
	stream
		nextPutAll: ' {';
		cr.
	aRuleset items do: 
			[:e |
			self accept: e.
			stream
				nextPutAll: ';';
				cr].
	stream
		nextPutAll: '}';
		cr
]
