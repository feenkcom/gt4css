"
I exemplify {{gtClass:GtPharoRenameCSSClassCoderController}} with a Rust text editor and `BlScripter`, similar to {{gtClass:GtPharoRenameVariableModelRustEditorExamples}}. The helpers are copies of the ones in that class because Gt4CSS does not depend on its package, see the method protocol `helpers`.
"
Class {
	#name : #GtPharoRenameCSSClassRustEditorExamples,
	#superclass : #Object,
	#category : #'Gt4CSS-Examples-RustEditor'
}

{ #category : #helpers }
GtPharoRenameCSSClassRustEditorExamples >> assert: aScripter editorMode: isEditable [
	aScripter assert
		label: ('Assert variable editor is in {1} mode' format: {isEditable ifTrue: [ 'editable' ] ifFalse: [ 'label' ]});
		satisfies: [ :anEditor | anEditor viewModel mode isEditable = isEditable ];
		// #'variable-editor';
		/ #editorElement;
		play
]

{ #category : #helpers }
GtPharoRenameCSSClassRustEditorExamples >> assert: aScripter occurrenceLabelsEqual: aString [
	aScripter assert
		label: ('Assert occurrence shows {1}' format: {aString printString});
		satisfies: [ :aLabel | aLabel text asString = aString ];
		// (#'variable-occurrence' asBlocElementId indexed: 1);
		/ #labelElement;
		play
]

{ #category : #helpers }
GtPharoRenameCSSClassRustEditorExamples >> assert: aScripter refactoringsPreviewIsVisible: aBoolean [
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
GtPharoRenameCSSClassRustEditorExamples >> createRustEditorWithMethod: aMethod variableNamed: aVariableName controllerClass: aControllerClass [
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

{ #category : #helpers }
GtPharoRenameCSSClassRustEditorExamples >> numberOfRenameRefactoringElementsIn: anEditorElement [
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
GtPharoRenameCSSClassRustEditorExamples >> rustEditorWithStyledMethod [
	<gtExample>
	<return: #GtExpandableSourceCoderElement>
	^ self
		createRustEditorWithMethod: self styledMethod
		variableNamed: 'le-nav-link'
		controllerClass: GtPharoRenameCSSClassCoderController
]

{ #category : #examples }
GtPharoRenameCSSClassRustEditorExamples >> rustScripterEditorWithStyledMethod [
	"The CSS class is in the method once, there are the editor and the refactorings preview."

	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self
			rustScripterFor: self rustEditorWithStyledMethod
			numberOfRenameElements: 2.
	self assert: aScripter refactoringsPreviewIsVisible: false.
	^ aScripter
]

{ #category : #examples }
GtPharoRenameCSSClassRustEditorExamples >> rustScripterEditorWithStyledMethod_escapeUninstalls [
	<gtExample>
	<return: #BlScripter>
	| aScripter anEditorElement |
	aScripter := self rustScripterEditorWithStyledMethod.
	anEditorElement := aScripter userData at: #editorElement.

	aScripter click
		label: 'Activate the CSS class editor';
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
GtPharoRenameCSSClassRustEditorExamples >> rustScripterEditorWithStyledMethod_invalidName [
	"A CSS class name does not contain spaces."

	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self rustScripterEditorWithStyledMethod.

	aScripter click
		label: 'Activate the CSS class editor';
		// #'variable-editor';
		play.

	aScripter editor
		label: 'Replace the name with "gt dummy"';
		selectAll;
		typeText: 'gt dummy';
		// #'variable-editor';
		play.

	self assert: aScripter refactoringsPreviewIsVisible: false.
	^ aScripter
]

{ #category : #examples }
GtPharoRenameCSSClassRustEditorExamples >> rustScripterEditorWithStyledMethod_refactoringsPreview [
	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self rustScripterEditorWithStyledMethod.

	aScripter click
		label: 'Activate the CSS class editor';
		// #'variable-editor';
		play.

	aScripter editor
		label: 'Replace the name with "a12345"';
		selectAll;
		typeText: 'a12345';
		// #'variable-editor';
		play.

	self assert: aScripter refactoringsPreviewIsVisible: true.

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
GtPharoRenameCSSClassRustEditorExamples >> rustScripterFor: aCoderElement numberOfRenameElements: aNumber [
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

{ #category : #examples }
GtPharoRenameCSSClassRustEditorExamples >> styledMethod [
	<gtExample>
	<return: #CompiledMethod>
	^ GtCSSFileSamples >> #writeOn:
]

{ #category : #helpers }
GtPharoRenameCSSClassRustEditorExamples >> variableNodeNamed: aString in: anAst [
	"The first variable with the given name or the first literal with the given value."

	anAst allNodesDo: [ :each | 
		((each isVariable and: [ each source = aString ])
			or: [ each isLiteral
					and: [ each isErrorNode not and: [ each literalValue = aString ] ] ])
			ifTrue: [ ^ each ] ].
	^ self error: 'Variable ' , aString , ' must exist'
]
