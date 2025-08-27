Class {
	#name : #GtCSSCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#traits : 'TGtCoderWithSelfObjectHolder + TGtCoderViewModelWithParentProperties',
	#classTraits : 'TGtCoderWithSelfObjectHolder classTrait + TGtCoderViewModelWithParentProperties classTrait',
	#category : #'Gt4CSS-Model'
}

{ #category : #'api - actions' }
GtCSSCoderViewModel >> allowSaveDueTo: anObject [ 
]

{ #category : #accessing }
GtCSSCoderViewModel >> behavior [
	^ self coderModel behavior
]

{ #category : #'as yet unclassified' }
GtCSSCoderViewModel >> collapsedTextPromise [
	^ self currentSelectorPromise then: [ :aSelector | aSelector asRopedText ]
]

{ #category : #'as yet unclassified' }
GtCSSCoderViewModel >> currentSelectorPromise [
	^ self coderModel currentSelectorPromise
]

{ #category : #'api - accessing' }
GtCSSCoderViewModel >> elementClass [
	^ GtCSSExpandableSourceCoderElement
]

{ #category : #'api - header' }
GtCSSCoderViewModel >> headerElementClass [
	^ GtCSSCoderHeaderElement
]

{ #category : #accessing }
GtCSSCoderViewModel >> highlighter: aStyler [
	self coder highlighter: aStyler
]

{ #category : #'as yet unclassified' }
GtCSSCoderViewModel >> isMeta [
	"Return true if the method is implemented in a pharo metaclass (~ class side)"

	<return: #Boolean>
	^ self coderModel isMeta
]

{ #category : #accessing }
GtCSSCoderViewModel >> preventSaveDueTo: anObject [
]

{ #category : #'api - actions' }
GtCSSCoderViewModel >> save [
	^ self coderModel save
]

{ #category : #accessing }
GtCSSCoderViewModel >> selector [
	^ self coderModel selector
]
