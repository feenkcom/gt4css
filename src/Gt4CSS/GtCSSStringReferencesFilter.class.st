Class {
	#name : #GtCSSStringReferencesFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'string'
	],
	#category : #'Gt4CSS-Filter'
}

{ #category : #accessing }
GtCSSStringReferencesFilter >> defaultFilterScope [
	^ AsyncCSSStringMethodsStream new
]

{ #category : #testing }
GtCSSStringReferencesFilter >> includesMethod: aCompiledMethod [
	| css ast |
	string ifNil: [ ^ true ].
	(aCompiledMethod pragmas anySatisfy: [ :each | each selector = #cssString ])
		ifFalse: [ ^ false ].
	css := [ (aCompiledMethod methodClass isInstanceSide
			ifTrue: [ aCompiledMethod methodClass new ]
			ifFalse: [ aCompiledMethod methodClass instanceSide ])
			perform: aCompiledMethod selector ] on: Error do: [ :ex | ex return: '' ].
	(css includesSubstring: string) ifFalse: [ ^ false ].
	ast := CSSParser parseWithErrors: css.
	^ self matchesAST: ast
]

{ #category : #testing }
GtCSSStringReferencesFilter >> matchesAST: ast [
	^ false
]

{ #category : #accessing }
GtCSSStringReferencesFilter >> resultType [
	^ GtAsyncCSSStringTypedGroupStream
]

{ #category : #accessing }
GtCSSStringReferencesFilter >> string [
	^ string
]

{ #category : #accessing }
GtCSSStringReferencesFilter >> string: anObject [
	string := anObject
]
