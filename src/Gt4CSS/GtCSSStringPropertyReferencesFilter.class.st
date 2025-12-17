Class {
	#name : #GtCSSStringPropertyReferencesFilter,
	#superclass : #GtCSSStringReferencesFilter,
	#category : 'Gt4CSS-Filter'
}

{ #category : #'instance creation' }
GtCSSStringPropertyReferencesFilter class >> forProperty: aString [
	^self new string: aString
]

{ #category : #'as yet unclassified' }
GtCSSStringPropertyReferencesFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: string printString;
		nextPutAll: ' gtCSSStringPropertyReferences'
]

{ #category : #accessing }
GtCSSStringPropertyReferencesFilter >> highlighter [
	^ GtCSSStringPropertyHighlighter new name: string
]

{ #category : #testing }
GtCSSStringPropertyReferencesFilter >> matchesAST: ast [
	ast
		withAllNodesOfType: CSSDeclarationNode
		do: [ :node | node name source = string ifTrue: [ ^ true ] ].
	^ false
]
