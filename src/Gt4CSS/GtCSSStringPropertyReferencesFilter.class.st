Class {
	#name : #GtCSSStringPropertyReferencesFilter,
	#superclass : #GtCSSStringReferencesFilter,
	#category : #'Gt4CSS-Filter'
}

{ #category : #'instance creation' }
GtCSSStringPropertyReferencesFilter class >> forProperty: aString [
	^self new string: aString
]

{ #category : #'as yet unclassified' }
GtCSSStringPropertyReferencesFilter >> matchesAST: ast [
	ast
		withAllNodesOfType: CSSDeclarationNode
		do: [ :node | node name source = string ifTrue: [ ^ true ] ].
	^ false
]
