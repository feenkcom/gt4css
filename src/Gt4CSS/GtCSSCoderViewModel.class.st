Class {
	#name : #GtCSSCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#category : #'Gt4CSS-Model'
}

{ #category : #'as yet unclassified' }
GtCSSCoderViewModel >> elementClass [
	^ GtCSSExpandableSourceCoderElement
]

{ #category : #'as yet unclassified' }
GtCSSCoderViewModel >> headerElementClass [
	^ GtCSSCoderHeaderElement
]

{ #category : #'as yet unclassified' }
GtCSSCoderViewModel >> save [
	^ self coderModel save
]
