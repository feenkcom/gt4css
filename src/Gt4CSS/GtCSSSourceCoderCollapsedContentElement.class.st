Class {
	#name : #GtCSSSourceCoderCollapsedContentElement,
	#superclass : #GtSourceCoderCollapsedContentElement,
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSSourceCoderCollapsedContentElement >> showPackageAndClass: aBoolean [
	header ifNotNil: [ header showPackageAndClass: aBoolean ]
]

{ #category : #'as yet unclassified' }
GtCSSSourceCoderCollapsedContentElement >> updateCollapsedTextLabel [
	label asyncPromise promise: textualCoderViewModel collapsedTextPromise
]
