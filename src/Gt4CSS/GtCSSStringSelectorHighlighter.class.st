Class {
	#name : #GtCSSStringSelectorHighlighter,
	#superclass : #GtCSSStringHighlighter,
	#category : 'Gt4CSS-Highlighter'
}

{ #category : #generated }
GtCSSStringSelectorHighlighter >> visitRuleset: aRuleset [
	super visitRuleset: aRuleset.
	aRuleset selectorParts
		do: [ :each | 
			each source = name
				ifTrue: [ text
						attributes: HighlightAttributes
						from: each startPosition
						to: each stopPosition ] ]
]
