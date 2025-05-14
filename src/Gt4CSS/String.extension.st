Extension { #name : #String }

{ #category : #'*Gt4CSS' }
String >> gtCSSClassMethodReferences [
	| astPattern |
	astPattern := self printString
			, ' `{:node | 
					node parent isMessage and: [ 
						| index |
						index := node parent arguments identityIndexOf: node.
						index > 0 
							and: [(node parent selectorParts at: index) = ''style:'' ] ] }'.
	^ self gtReferences & astPattern gtASTMatches
]

{ #category : #'*Gt4CSS' }
String >> gtCSSStringPropertyReferences [
	^ GtCSSStringPropertyReferencesFilter forProperty: self
]

{ #category : #'*Gt4CSS' }
String >> gtCSSStringSelectorReferences [
	^ GtCSSStringSelectorReferencesFilter forSelector: self
]
