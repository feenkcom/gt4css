Class {
	#name : #GtCSSCoderCollapsedContentElement,
	#superclass : #GtSourceCoderCollapsedContentElement,
	#category : #'Gt4CSS-UI'
}

{ #category : #initialization }
GtCSSCoderCollapsedContentElement >> initialize [
	super initialize.
	self removeChild: content
]

{ #category : #'as yet unclassified' }
GtCSSCoderCollapsedContentElement >> showPackageAndClass: aBoolean [
	header ifNotNil: [ header showPackageAndClass: aBoolean ]
]
