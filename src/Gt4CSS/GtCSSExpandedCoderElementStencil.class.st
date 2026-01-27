Class {
	#name : #GtCSSExpandedCoderElementStencil,
	#superclass : #GtCoderElementStencil,
	#category : 'Gt4CSS-UI'
}

{ #category : #'api - instantiation' }
GtCSSExpandedCoderElementStencil >> defaultElement [
	<return: #BlElement>
	^ GtCSSSourceCoderExpandedContentElement new
]
