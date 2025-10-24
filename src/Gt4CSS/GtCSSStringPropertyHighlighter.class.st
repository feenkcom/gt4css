Class {
	#name : #GtCSSStringPropertyHighlighter,
	#superclass : #GtCSSStringHighlighter,
	#category : 'Gt4CSS-Highlighter'
}

{ #category : #generated }
GtCSSStringPropertyHighlighter >> visitDeclaration: aDeclaration [
	super visitDeclaration: aDeclaration.
	aDeclaration name source = name
		ifTrue: [ text
				attributes: HighlightAttributes
				from: aDeclaration name startPosition
				to: aDeclaration name stopPosition ]
]
