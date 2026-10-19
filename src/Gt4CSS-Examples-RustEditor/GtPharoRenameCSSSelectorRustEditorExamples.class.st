"
I exemplify {{gtClass:GtPharoRenameCSSSelectorCoderController}} with a Rust text editor and `BlScripter`, on the CSS code of {{gtMethod:GtCSSFileSamples>>#lepiter_common}}. The helpers are copies of the ones in {{gtClass:GtPharoRenameVariableModelRustEditorExamples}}, see the method protocol `helpers`. The space is tall because the first selector is far from the beginning of the CSS code.
"
Class {
	#name : #GtPharoRenameCSSSelectorRustEditorExamples,
	#superclass : #Object,
	#category : #'Gt4CSS-Examples-RustEditor'
}

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> assert: aScripter editorMode: isEditable [
	aScripter assert
		label: ('Assert variable editor is in {1} mode' format: {isEditable ifTrue: [ 'editable' ] ifFalse: [ 'label' ]});
		satisfies: [ :anEditor | anEditor viewModel mode isEditable = isEditable ];
		// #'variable-editor';
		/ #editorElement;
		play
]

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> assert: aScripter occurrenceLabelsEqual: aString [
	aScripter assert
		label: ('Assert occurrence shows {1}' format: {aString printString});
		satisfies: [ :aLabel | aLabel text asString = aString ];
		// (#'variable-occurrence' asBlocElementId indexed: 1);
		/ #labelElement;
		play
]

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> assert: aScripter refactoringsPreviewIsVisible: aBoolean [
	aScripter assert
		label: ('Assert refactorings preview is {1}'
				format: {aBoolean ifTrue: [ 'visible' ] ifFalse: [ 'hidden' ]});
		satisfies: [ :anElement | 
			aBoolean
				ifTrue: [ anElement visibility isVisible ]
				ifFalse: [ anElement visibility isHidden ] ];
		// #'variable-refactorings-preview';
		play
]

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> createRustEditorWithMethod: aMethod variableNamed: aVariableName controllerClass: aControllerClass [
	"Create a coder element with a Rust text editor. When the editor is styled, a variable rename controller is installed on the first variable with the given name."

	| aCoderElement aTextEditorElement aDocumentId aController aCoder aCoderViewModel aRecorder |
	aDocumentId := nil.
	aCoder := GtPharoMethodCoder forMethod: aMethod.
	aCoderViewModel := aCoder asCoderViewModel.
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder
		addSignalClass: GtTextEditorSignal;
		observeAnnouncer: aCoderViewModel announcer labeled: 'coder view model'.

	aRecorder
		runDuring: [ aCoderElement := GtExpandableSourceCoderElement new
					expandedElementStencil: GtExpandedCoderElementWithRustTextEditorStencil new;
					textualCoderViewModel: aCoderViewModel;
					expand.

			BlTaskAction
				enqueueElement: aCoderElement
				action: [ aTextEditorElement := (aCoderElement query // GtTextEditorElement) anyOne.
					self
						assert: [ aTextEditorElement isNotNil ]
						description: [ 'Text editor element must exist.' ].
					aTextEditorElement privateEditorHandle enableInMemoryCommandsRecorder.
					aTextEditorElement
						when: BrTextEditorModifiedEvent
							do: [ :anEvent | aDocumentId := anEvent documentId ];
						styler: (GtPharoStyler new coderViewModel: aCoderViewModel);
						when: BrTextStyledEvent
							doOnce: [ :anEvent | 
								| anAstFuture |
								anAstFuture := aCoderViewModel coderAstFuture
										map: [ :aCoderAst | 
											BlTaskAction
												enqueueElement: anEvent currentTarget
												action: [ anEvent currentTarget
														assert: [ aDocumentId isNotNil ]
														description: [ 'Document ID must be non-nil.' ].
													aController := aControllerClass new
															originalNode: (self variableNodeNamed: aVariableName in: aCoderAst ast);
															documentId: aDocumentId;
															editorElement: aTextEditorElement;
															sourceCoderViewModel: aCoderViewModel;
															install.
													aController variableModel
														ifNotNil: [ :aVariableModel | 
															aRecorder
																observeAnnouncer: aVariableModel announcer
																labeled: 'rename variable model' ] ] ].
								anAstFuture await: aCoderViewModel class commonExecutionConfiguration ].

					aTextEditorElement text: aMethod sourceCode asRopedText.

					aTextEditorElement userData at: #coderViewModel put: aCoderViewModel.
					aTextEditorElement userData at: #timelineRecorder put: aRecorder ] ].

	aCoderElement userData at: #coderViewModel put: aCoderViewModel.
	aCoderElement userData at: #timelineRecorder put: aRecorder.

	^ aCoderElement
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> cssMethod [
	<gtExample>
	<return: #CompiledMethod>
	^ GtCSSFileSamples >> #lepiter_common
]

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> numberOfRenameRefactoringElementsIn: anEditorElement [
	^ anEditorElement children
		count: [ :eachChild | 
			eachChild id
				ifNotNil: [ :anId | 
					anId asSymbol
						ifNotNil: [ :aSymbol | aSymbol beginsWith: 'variable-' ]
						ifNil: [ false ] ]
				ifNil: [ false ] ]
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> numberOfSelectors [
	"The number of selectors le-nav-link in the CSS code."

	| aCount |
	aCount := 0.
	(GtCSSCoderModel new forMethod: self cssMethod) astSync
		allNodesOfType: CSSIdentifierNode
		do: [ :each | 
			(each source = 'le-nav-link'
				and: [ (each parent isKindOf: CSSRulesetNode)
						and: [ each parent selectorParts identityIncludes: each ] ]) ifTrue: [ aCount := aCount + 1 ] ].
	^ aCount
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> rustEditorWithCSSMethod [
	"The editor shows the CSS code returned by the method."

	<gtExample>
	<return: #GtExpandableSourceCoderElement>
	^ self
		createRustEditorWithMethod: self cssMethod
		variableNamed: 'le-nav-link'
		controllerClass: GtPharoRenameCSSSelectorCoderController
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> rustScripterEditorWithCSSMethod [
	"There are the editor, all other selectors, and the refactorings preview."

	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self
			rustScripterFor: self rustEditorWithCSSMethod
			numberOfRenameElements: self numberOfSelectors + 1.
	aScripter
		doStep: [ :s | 
			s
				label: 'Set space extent';
				block: [ :aSpace | aSpace extent: self spaceExtent ];
				onSpace ].
	self assert: aScripter refactoringsPreviewIsVisible: false.
	^ aScripter
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> rustScripterEditorWithCSSMethod_escapeUninstalls [
	<gtExample>
	<return: #BlScripter>
	| aScripter anEditorElement |
	aScripter := self rustScripterEditorWithCSSMethod.
	anEditorElement := aScripter userData at: #editorElement.

	aScripter click
		label: 'Activate the selector editor';
		// #'variable-editor';
		play.

	aScripter keyPress
		label: 'Press Escape';
		key: BlKeyboardKey escape;
		play.

	aScripter wait
		label: 'Wait until all rename elements are removed';
		forCondition: [ :aSpace | (self numberOfRenameRefactoringElementsIn: anEditorElement) = 0 ]
			pulseDuring: 5 seconds;
		play.

	self assert: (anEditorElement userData includesKey: #variableModel) not.
	^ aScripter
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> rustScripterEditorWithCSSMethod_invalidName [
	"A CSS class name cannot start with a digit."

	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self rustScripterEditorWithCSSMethod.

	aScripter click
		label: 'Activate the selector editor';
		// #'variable-editor';
		play.

	aScripter editor
		label: 'Replace the name with "1abc"';
		selectAll;
		typeText: '1abc';
		// #'variable-editor';
		play.

	self assert: aScripter refactoringsPreviewIsVisible: false.
	^ aScripter
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> rustScripterEditorWithCSSMethod_refactoringsPreview [
	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self rustScripterEditorWithCSSMethod.

	aScripter click
		label: 'Activate the selector editor';
		// #'variable-editor';
		play.

	aScripter editor
		label: 'Replace the name with "a12345"';
		selectAll;
		typeText: 'a12345';
		// #'variable-editor';
		play.

	self assert: aScripter refactoringsPreviewIsVisible: true.
	self assert: aScripter occurrenceLabelsEqual: 'a12345'.

	aScripter editor
		label: 'Replace the name with the original one';
		selectAll;
		typeText: 'le-nav-link';
		// #'variable-editor';
		play.

	self assert: aScripter refactoringsPreviewIsVisible: false.
	^ aScripter
]

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> rustScripterFor: aCoderElement numberOfRenameElements: aNumber [
	| aScripter anEditorElement aVariableModel aRecorder |
	aRecorder := aCoderElement userData at: #timelineRecorder.
	aScripter := BlScripter new.
	aScripter userData at: #timelineRecorder put: aRecorder.

	aRecorder
		runDuring: [ aScripter element: aCoderElement.
			anEditorElement := (aScripter element query // GtTextEditorElement) anyOne.
			self
				assert: anEditorElement isNotNil
				description: [ 'Text editor element must exist' ].

			aScripter wait
				forCondition: [ :aSpace :theScripter | 
						anEditorElement userData
							at: #variableModel
							ifPresent: [ :theModel | 
								theModel ifNotNil: [ aVariableModel := theModel ].
								theModel isNotNil ]
							ifAbsent: [ false ] ]
					pulseDuring: 5 seconds;
				play.
			self assert: aVariableModel isNotNil.
			aScripter model: aVariableModel.

			aScripter wait
				waitRustEditorRendered: anEditorElement pulseDuring: 5 seconds;
				play.

			aScripter wait
				label: 'Wait for all rename elements';
				forCondition: [ :aSpace | (self numberOfRenameRefactoringElementsIn: anEditorElement) = aNumber ]
					pulseDuring: 5 seconds;
				play ].

	aScripter userData at: #editorElement put: anEditorElement.
	self assert: aScripter editorMode: true.

	^ aScripter
]

{ #category : #helpers }
GtPharoRenameCSSSelectorRustEditorExamples >> spaceExtent [
	"The CSS code is long and the first selector le-nav-link is far from its beginning, so the space must be tall enough to show it."

	^ 800 @ 3000
]

{ #category : #examples }
GtPharoRenameCSSSelectorRustEditorExamples >> variableNodeNamed: aString in: anAst [
	"The first selector with the given name in the CSS code."

	anAst
		allNodesOfType: CSSIdentifierNode
		do: [ :each | 
			(each source = aString
				and: [ (each parent isKindOf: CSSRulesetNode)
						and: [ each parent selectorParts identityIncludes: each ] ]) ifTrue: [ ^ each ] ].
	^ self error: 'Selector ' , aString , ' must exist'
]
