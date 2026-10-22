Extension { #name : #GtPharoSourceCoder }

{ #category : #'*Gt4CSS' }
GtPharoSourceCoder >> renameCSSClassChoosingImplementation: aNode in: aSourceCoderViewModel for: anElement [
	"Use the attribute based controller {{gtClass:GtPharoRenameCSSClassCoderController}} if the new rename implementation is enabled, otherwise the old one."

	GtPharoCoderSettings displayNewRenameImplementationContextMenuItem
		ifFalse: [ ^ (GtCSSStringRenameSelectorController new
				sourceCoderViewModel: aSourceCoderViewModel;
				originalNode: aNode;
				documentId: aSourceCoderViewModel documentId) execute ].
	GtPharoRenameCSSClassCoderController new
		originalNode: aNode;
		editorElement: anElement;
		documentId: aSourceCoderViewModel documentId;
		sourceCoderViewModel: aSourceCoderViewModel;
		install
]
