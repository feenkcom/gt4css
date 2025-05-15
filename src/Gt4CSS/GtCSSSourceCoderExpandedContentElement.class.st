Class {
	#name : #GtCSSSourceCoderExpandedContentElement,
	#superclass : #GtSourceCoderExpandedContentElement,
	#instVars : [
		'lspModel'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #updating }
GtCSSSourceCoderExpandedContentElement >> editorChangedTo: aString [
	self lspFile ifNotNil: [ :file | file source: aString ]
]

{ #category : #accessing }
GtCSSSourceCoderExpandedContentElement >> lspFile [
	^ textualCoderViewModel
		ifNotNil: [ lspModel
				ifNotNil: [ | fileRef lspFile |
					fileRef := lspModel filename
							/ textualCoderViewModel coder methodBehavior behavior name
							/ (textualCoderViewModel coder selector , '.css').
					(lspModel fileFor: fileRef)
						ifNil: [ fileRef exists
								ifFalse: [ fileRef parent ensureCreateDirectory.
									fileRef
										writeStreamDo: [ :stream | stream nextPutAll: textualCoderViewModel coder currentSourceString ] ].
							lspFile := lspModel existingOrCreatefileFor: fileRef.
							lspFile open.
							^ lspFile ] ] ]
]

{ #category : #accessing }
GtCSSSourceCoderExpandedContentElement >> lspModel [
	^ lspModel
]

{ #category : #accessing }
GtCSSSourceCoderExpandedContentElement >> lspModel: anObject [
	lspModel := anObject.
	editorElement ifNotNil: [ self updateAptitude: editorElement ]
]

{ #category : #'instance creation' }
GtCSSSourceCoderExpandedContentElement >> newEditorElement [
	| editor |
	editor := GtCSSSourceCoderEditorElement new.
	self updateAptitude: editor.
	editor editor
		when: BrTextEditorInsertedEvent
			do: [ :event | self editorChangedTo: event source text asString ];
		when: BrTextEditorDeletedEvent
			do: [ :event | self editorChangedTo: event source text asString ];
		when: BlInfiniteDataSourceChanged
			do: [ :event | self editorChangedTo: event source text asString ].
	^ editor
]

{ #category : #'api - textual coder view model' }
GtCSSSourceCoderExpandedContentElement >> onPostTextualCoderViewModelChanged [
	super onPostTextualCoderViewModelChanged.
	self updateAptitude: editorElement
]

{ #category : #'as yet unclassified' }
GtCSSSourceCoderExpandedContentElement >> updateAptitude: editor [
	| aptitude |
	aptitude := GtLSPEditorAptitude new.
	aptitude lspFile: self lspFile.
	editor aptitude: aptitude
]
