Class {
	#name : #GtCSSCoderCollapsedContentElement,
	#superclass : #GtSourceCoderCollapsedContentElement,
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSCoderCollapsedContentElement >> initialize [
	super initialize.
	self removeChild: content
]
