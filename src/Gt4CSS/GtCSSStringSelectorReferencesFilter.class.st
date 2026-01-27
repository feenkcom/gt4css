Class {
	#name : #GtCSSStringSelectorReferencesFilter,
	#superclass : #GtCSSStringReferencesFilter,
	#category : 'Gt4CSS-Filter'
}

{ #category : #'instance creation' }
GtCSSStringSelectorReferencesFilter class >> forSelector: aString [
	^ self new string: aString
]

{ #category : #'as yet unclassified' }
GtCSSStringSelectorReferencesFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: string printString;
		nextPutAll: ' gtCSSStringSelectorReferences'
]

{ #category : #accessing }
GtCSSStringSelectorReferencesFilter >> highlighter [
	^ GtCSSStringSelectorHighlighter new name: string
]

{ #category : #testing }
GtCSSStringSelectorReferencesFilter >> matchesAST: ast [
	ast
		withAllNodesOfType: CSSRulesetNode
		do: [ :node | 
			(node selectorParts anySatisfy: [ :each | each source = string ])
				ifTrue: [ ^ true ] ].
	^ false
]
