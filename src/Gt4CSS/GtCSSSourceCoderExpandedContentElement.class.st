Class {
	#name : #GtCSSSourceCoderExpandedContentElement,
	#superclass : #GtSourceCoderExpandedContentElement,
	#instVars : [
		'lspModel',
		'label'
	],
	#category : 'Gt4CSS-UI'
}

{ #category : #updating }
GtCSSSourceCoderExpandedContentElement >> editorChangedTo: aString [
	self lspFile ifNotNil: [ :file | file source: aString ]
]

{ #category : #'as yet unclassified' }
GtCSSSourceCoderExpandedContentElement >> initialize [
	super initialize.
	label := BlAttributedTextElement new
			id: GtSourceCoderCollapsedTextId;
			editorMeasurement;
			bold;
			glamorousCodeFont;
			foreground: self theme label defaultTextForeground.
	self addChildFirst: label
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
GtCSSSourceCoderExpandedContentElement >> showPackageAndClass: aBoolean [
	header ifNotNil: [ header showPackageAndClass: aBoolean ]
]

{ #category : #'as yet unclassified' }
GtCSSSourceCoderExpandedContentElement >> updateAptitude: editor [
	| aptitude |
	aptitude := GtLSPEditorAptitude new.
	aptitude lspFile: self lspFile.
	textualCoderViewModel
		ifNotNil: [aptitude styler: textualCoderViewModel compositeStyler].
	editor aptitude: aptitude.
	textualCoderViewModel ifNotNil: [self updateHeaderLabel: editor].
	editor addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
				menu: [editor createContextMenu])
]

{ #category : #updating }
GtCSSSourceCoderExpandedContentElement >> updateHeaderLabel: editor [
	label text: textualCoderViewModel coder selector asRopedText.
	label addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
				menu: [self createHeaderContextMenu])
]
