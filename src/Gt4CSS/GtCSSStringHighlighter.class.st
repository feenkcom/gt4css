Class {
	#name : #GtCSSStringHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#traits : 'TCSSProgramNodeVisitor',
	#classTraits : 'TCSSProgramNodeVisitor classTrait',
	#instVars : [
		'name'
	],
	#category : #'Gt4CSS-Highlighter'
}

{ #category : #accessing }
GtCSSStringHighlighter >> name [
	^ name
]

{ #category : #accessing }
GtCSSStringHighlighter >> name: anObject [
	name := anObject
]

{ #category : #'api - styling' }
GtCSSStringHighlighter >> style: aText ast: theAst [
	text := aText.
	[ self accept: theAst ]
		on: Error
		do: [ :e | (GtStylerErrorSignal new signaledError: e) emit ].
	text := nil
]
