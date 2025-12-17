Class {
	#name : #GtCSSSourceCoderEditorElement,
	#superclass : #GtSourceCoderEditorElement,
	#category : 'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSSourceCoderEditorElement >> createHeaderContextMenu [
	^(BrMenuItems new)
		addItemLabel: 'References'
			action: 
				[:anElement :aButtonModel :anEvent |
				anElement phlow
					spawnObject: textualCoderViewModel coder selector gtReferences];
		yourself
]

{ #category : #initialization }
GtCSSSourceCoderEditorElement >> defaultTextEditorModel [
	^ GtLSPEditorModel withEditorMode: self defaultTextEditorMode
]
