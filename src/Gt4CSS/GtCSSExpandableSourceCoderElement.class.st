Class {
	#name : #GtCSSExpandableSourceCoderElement,
	#superclass : #GtExpandableSourceCoderElement,
	#instVars : [
		'lspModel',
		'showPackageAndClass'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSExpandableSourceCoderElement >> initialize [
	super initialize.
	showPackageAndClass := false
]

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
	aCollapsedElement showPackageAndClass: showPackageAndClass.
	^ aCollapsedElement
]

{ #category : #'private - instance creation' }
GtCSSExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtCSSSourceCoderExpandedContentElement new.
	anExpandedElement lspModel: lspModel.
	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].
	anExpandedElement showPackageAndClass: showPackageAndClass.
	^ anExpandedElement
]

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> showPackageAndClass [
	^ showPackageAndClass
]

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> showPackageAndClass: anObject [
	showPackageAndClass := anObject.
	self updateHeaders
]

{ #category : #'private - update' }
GtCSSExpandableSourceCoderElement >> updateElement [
	super updateElement.
	textualCoderViewModel expanded
		ifTrue: [ expandedElement ifNotNil: [ expandedElement lspModel: lspModel ] ]
]

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> updateHeaders [
	expandedElement
		ifNotNil: [ expandedElement showPackageAndClass: showPackageAndClass ].
	collapsedElement
		ifNotNil: [ collapsedElement showPackageAndClass: showPackageAndClass ]
]
