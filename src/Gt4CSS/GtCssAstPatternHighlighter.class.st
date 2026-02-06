Class {
	#name : #GtCssAstPatternHighlighter,
	#superclass : #GtCSSStringHighlighter,
	#instVars : [
		'ast'
	],
	#category : #'Gt4CSS-Highlighter'
}

{ #category : #'instance creation' }
GtCssAstPatternHighlighter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #accessing }
GtCssAstPatternHighlighter >> ast [
	<return: #GtPharoProgramNode>

	^ ast
]

{ #category : #accessing }
GtCssAstPatternHighlighter >> ast: aGtPharoProgramNode [
	ast := aGtPharoProgramNode
]

{ #category : #visiting }
GtCssAstPatternHighlighter >> visitSmaCCParseNode: aNode [	
	(ast match: aNode inContext: Dictionary new)
		ifTrue: [ text
				attributes: HighlightAttributes
				from: aNode startPosition
				to: aNode stopPosition ]
		ifFalse: [ super visitSmaCCParseNode: aNode ]
]
