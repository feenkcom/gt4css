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

{ #category : #'private - instance creation' }
GtCSSExpandableSourceCoderElement >> newCollapsedElement [
	| aCollapsedElement |
	aCollapsedElement := GtCSSCoderCollapsedContentElement new.
	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignCollapsedCoder: aCoder to: aCollapsedElement ].
	^ aCollapsedElement
]

{ #category : #'private - instance creation' }
GtCSSExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtCSSSourceCoderExpandedContentElement new.
	anExpandedElement lspModel: lspModel.
	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].
	^ anExpandedElement
]

{ #category : #'private - update' }
GtCSSExpandableSourceCoderElement >> updateElement [
	super updateElement.
	textualCoderViewModel expanded
		ifTrue: [ expandedElement ifNotNil: [ expandedElement lspModel: lspModel ] ]
]
