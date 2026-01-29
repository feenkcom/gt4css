Class {
	#name : #GtCSSSourceCoderCollapsedContentElement,
	#superclass : #GtSourceCoderCollapsedContentElement,
	#category : 'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSSourceCoderCollapsedContentElement >> showPackageAndClass: aBoolean [
	header ifNotNil: [ header showPackageAndClass: aBoolean ]
]
