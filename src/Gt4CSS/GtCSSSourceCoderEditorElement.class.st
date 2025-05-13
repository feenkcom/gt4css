Class {
	#name : #GtCSSSourceCoderEditorElement,
	#superclass : #GtSourceCoderEditorElement,
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSSourceCoderEditorElement >> defaultTextEditorModel [
	^ GtLSPEditorModel withEditorMode: self defaultTextEditorMode
]
