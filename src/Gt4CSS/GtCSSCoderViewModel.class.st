Class {
	#name : #GtCSSCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#category : #'Gt4CSS-Model'
}

{ #category : #'api - accessing' }
GtCSSCoderViewModel >> elementClass [
	^ GtCSSExpandableSourceCoderElement
]

{ #category : #'api - header' }
GtCSSCoderViewModel >> headerElementClass [
	^ GtCSSCoderHeaderElement
]

{ #category : #'api - actions' }
GtCSSCoderViewModel >> save [
	^ self coderModel save
]
