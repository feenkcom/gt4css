"
I exemplify {{gtClass:GtPharoRenameCSSClassCoderController}} on {{gtMethod:GtCSSFileSamples>>#writeOn:}}. Refactorings are executed only on the refactoring model, the image is not changed. The widgets of the rename are exemplified with a Rust text editor in {{gtClass:GtPharoRenameCSSClassRustEditorExamples}}.
"
Class {
	#name : #GtPharoRenameCSSClassCoderControllerExamples,
	#superclass : #Object,
	#category : #'Gt4CSS-Examples-RustEditor'
}

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> cssClassNode [
	"The first string with the CSS class."

	<gtExample>
	<return: #GtPharoStringNode>
	self styledCoder astSync
		allNodesDo: [ :each | 
			(each isLiteral and: [ each isErrorNode not and: [ each literalValue = 'le-nav-link' ] ])
				ifTrue: [ ^ each ] ].
	^ self error: 'The CSS class must exist'
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> editorWithStyledMethod [
	<gtExample>
	<return: #GtTextEditorElement>
	| anEditor |
	anEditor := GtTextEditorElement new hMatchParent; vFitContentLimited.
	anEditor text: self styledMethod sourceCode asRopedText.
	^ anEditor
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> installedController [
	<gtExample>
	<return: #GtPharoRenameCSSClassCoderController>
	| aController aModel aSource |
	aController := self newInstalledController.
	aModel := aController variableModel.
	aSource := self styledMethod sourceCode.

	self assert: aModel originalName equals: 'le-nav-link'.
	self assert: aModel originalIntervals size equals: 1.
	aModel originalIntervals
		do: [ :eachInterval | 
			self
				assert: (aSource copyFrom: eachInterval first to: eachInterval last)
				equals: 'le-nav-link' ].
	"the editor and the refactorings preview, the literal is used once"
	self assert: aController attributeTags size equals: 2.
	^ aController
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> installedController_cancel [
	<gtExample>
	<return: #GtPharoRenameCSSClassCoderController>
	| aController anOriginalSource |
	aController := self newInstalledController.
	anOriginalSource := aController sourceCoderViewModel sourceText asString.

	aController variableModel updateCurrentName: 'x' source: self.
	aController variableModel requestCancelSource: self.

	self assert: aController sourceCoderViewModel sourceText asString equals: anOriginalSource.
	self assert: aController attributeTags isNil.
	self assert: aController editorElement userData isEmpty.
	^ aController
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> installedController_refactorings [
	"The refactoring is only applied to the refactoring model, the image is not changed."

	<gtExample>
	<return: #GtPharoRenameCSSClassCoderController>
	| aController aModel someRefactorings aModelClass aNewSource |
	aController := self newInstalledController.
	aModel := aController variableModel.
	self assert: aController computeRefactorings isEmpty.

	aModel updateCurrentName: 'a12345a' source: self.
	someRefactorings := aController computeRefactorings.
	self assert: someRefactorings size equals: 1.
	self assert: someRefactorings first class equals: GtCSSStringRenameSelectorRefactoring.

	someRefactorings first primitiveExecute.
	aModelClass := someRefactorings first model classFor: GtCSSFileSamples.
	aNewSource := aModelClass sourceCodeFor: #writeOn:.
	self assert: (aNewSource includesSubstring: '''a12345a''').
	self assert: (aNewSource includesSubstring: 'le-nav-link') not.
	self
		assert: (self styledMethod sourceCode includesSubstring: 'le-nav-link').
	"the definition in the CSS code is renamed too"
	self
		assert: ((someRefactorings first model classFor: GtCSSFileSamples)
				sourceCodeFor: #lepiter_common)
		equals: ((GtCSSFileSamples sourceCodeAt: #lepiter_common)
				copyReplaceAll: 'le-nav-link'
				with: 'a12345a').
	^ aController
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> installedController_validation [
	<gtExample>
	<return: #GtPharoRenameCSSClassCoderController>
	| aModel |
	aModel := self newInstalledController variableModel.

	aModel updateCurrentName: 'a12345a' source: self.
	self assert: aModel isValid.
	aModel updateCurrentName: '_dummy' source: self.
	self assert: aModel isValid.
	aModel updateCurrentName: '1dummy' source: self.
	self assert: aModel isValid not.
	aModel updateCurrentName: 'dummy class' source: self.
	self assert: aModel isValid not.
	aModel updateCurrentName: '' source: self.
	self assert: aModel isValid not.
	^ self newInstalledController
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> newInstalledController [
	<gtExample>
	<return: #GtPharoRenameCSSClassCoderController>
	^ GtPharoRenameCSSClassCoderController new
		originalNode: self cssClassNode;
		documentId: nil;
		editorElement: self editorWithStyledMethod;
		sourceCoderViewModel: self styledCoderViewModel;
		install
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> renameCSSClassWithNewImplementation [
	"The setting selects the attribute based controller."

	<gtExample>
	<return: #GtTextEditorElement>
	| anEditor |
	anEditor := self editorWithStyledMethod.
	self
		withNewRenameImplementation: true
		do: [ self styledCoder
				renameCSSClassChoosingImplementation: self cssClassNode
				in: self styledCoderViewModel
				for: anEditor ].
	self
		assert: (anEditor userData at: #variableController) class
		equals: GtPharoRenameCSSClassCoderController.
	^ anEditor
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> renameCSSClassWithOldImplementation [
	"The old controller does not install the attribute based one."

	<gtExample>
	<return: #GtTextEditorElement>
	| anEditor |
	anEditor := self editorWithStyledMethod.
	self
		withNewRenameImplementation: false
		do: [ self styledCoder
				renameCSSClassChoosingImplementation: self cssClassNode
				in: self styledCoderViewModel
				for: anEditor ].
	self assert: (anEditor userData includesKey: #variableController) not.
	^ anEditor
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> styledCoder [
	<gtExample>
	<return: #GtPharoMethodCoder>
	^ GtPharoMethodCoder forMethod: self styledMethod
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> styledCoderViewModel [
	<gtExample>
	<return: #GtPharoMethodCoderViewModel>
	^ self styledCoder asCoderViewModel
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> styledMethod [
	<gtExample>
	<return: #CompiledMethod>
	^ GtCSSFileSamples >> #writeOn:
]

{ #category : #examples }
GtPharoRenameCSSClassCoderControllerExamples >> withNewRenameImplementation: aBoolean do: aBlock [
	| aPreviousValue |
	aPreviousValue := GtPharoCoderSettings displayNewRenameImplementationContextMenuItem.
	^ [ GtPharoCoderSettings displayNewRenameImplementationContextMenuItem: aBoolean.
		aBlock value ]
		ensure: [ GtPharoCoderSettings
				displayNewRenameImplementationContextMenuItem: aPreviousValue ]
]
