Class {
	#name : #GtCSSExpandableSourceCoderElement,
	#superclass : #GtExpandableSourceCoderElement,
	#instVars : [
		'lspModel'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> lspModel [
	^ lspModel
]

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> lspModel: anObject [
	lspModel := anObject.
	expandedElement ifNotNil: [ expandedElement lspModel: lspModel ]
]

{ #category : #'as yet unclassified' }
GtCSSExpandableSourceCoderElement >> newCollapsedElement [
	| aCollapsedElement |
	aCollapsedElement := GtCSSCoderCollapsedContentElement new.
	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignCollapsedCoder: aCoder to: aCollapsedElement ].
	^ aCollapsedElement
]

{ #category : #'as yet unclassified' }
GtCSSExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtCSSSourceCoderExpandedContentElement new.
	anExpandedElement lspModel: lspModel.
	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].
	^ anExpandedElement
]

{ #category : #'as yet unclassified' }
GtCSSExpandableSourceCoderElement >> updateElement [
	super updateElement.
	textualCoderViewModel expanded
		ifTrue: [ expandedElement ifNotNil: [ expandedElement lspModel: lspModel ] ]
]
