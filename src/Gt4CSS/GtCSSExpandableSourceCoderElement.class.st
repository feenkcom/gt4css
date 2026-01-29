Class {
	#name : #GtCSSExpandableSourceCoderElement,
	#superclass : #GtExpandableMethodCoderElement,
	#instVars : [
		'lspModel',
		'showPackageAndClass'
	],
	#category : 'Gt4CSS-UI'
}

{ #category : #initialization }
GtCSSExpandableSourceCoderElement >> defaultCollapsedElementStencil [
	^ GtCSSCollapsedCoderElementStencil new
]

{ #category : #initialization }
GtCSSExpandableSourceCoderElement >> defaultExpandedElementStencil [
	^ GtCSSExpandedCoderElementStencil new
]

{ #category : #initialization }
GtCSSExpandableSourceCoderElement >> initialize [
	super initialize.
	showPackageAndClass := false.
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
	aCollapsedElement := super newCollapsedElement.
	
	aCollapsedElement showPackageAndClass: showPackageAndClass.
	
	^ aCollapsedElement
]

{ #category : #'private - instance creation' }
GtCSSExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := super newExpandedElement.
	anExpandedElement lspModel: lspModel.
	anExpandedElement showPackageAndClass: showPackageAndClass.
	^ anExpandedElement
]

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> showPackageAndClass [
	^ showPackageAndClass
]

{ #category : #accessing }
GtCSSExpandableSourceCoderElement >> showPackageAndClass: aBoolean [
	showPackageAndClass := aBoolean.
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
