Class {
	#name : #GtCSSSourceCoderEditorElement,
	#superclass : #GtSourceCoderEditorElement,
	#category : #'Gt4CSS-UI'
}

{ #category : #initialization }
GtCSSSourceCoderEditorElement >> defaultTextEditorModel [
	^ GtLSPEditorModel withEditorMode: self defaultTextEditorMode
]
