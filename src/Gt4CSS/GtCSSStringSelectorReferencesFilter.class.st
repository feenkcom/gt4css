Class {
	#name : #GtCSSStringSelectorReferencesFilter,
	#superclass : #GtCSSStringReferencesFilter,
	#category : #'Gt4CSS-Filter'
}

{ #category : #'instance creation' }
GtCSSStringSelectorReferencesFilter class >> forSelector: aString [
	^ self new string: aString
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
