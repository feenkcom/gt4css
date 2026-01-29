"
I create a basic collapsed coder element used by {{gtClass:GtCSSExpandableSourceCoderElement}}. 
Such collapsed coder element is created in the {{gtMethod:GtCSSExpandableSourceCoderElement>>#newCollapsedElement}} method. 
Users can set their own stencil using {{gtMethod:GtCSSCollapsedCoderElementStencil class>>#defaultStencil:}}. 

"
Class {
	#name : #GtCSSCollapsedCoderElementStencil,
	#superclass : #GtCoderElementStencil,
	#category : 'Gt4CSS-UI'
}

{ #category : #'api - instantiation' }
GtCSSCollapsedCoderElementStencil >> defaultElement [
	<return: #BlElement>
	^ GtCSSSourceCoderCollapsedContentElement new
]
