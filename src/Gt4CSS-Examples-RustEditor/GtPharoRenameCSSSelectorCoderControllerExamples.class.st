"
I exemplify {{gtClass:GtPharoRenameCSSSelectorCoderController}} on the CSS code of {{gtMethod:GtCSSFileSamples>>#lepiter_common}}. Refactorings are executed only on the refactoring model, the image is not changed. The widgets of the rename are exemplified with a Rust text editor in {{gtClass:GtPharoRenameCSSSelectorRustEditorExamples}}.
"
Class {
	#name : #GtPharoRenameCSSSelectorCoderControllerExamples,
	#superclass : #Object,
	#category : #'Gt4CSS-Examples-RustEditor'
}

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> cssCoder [
	"The coder of a method with CSS code is a CSS coder, its text is the CSS code."

	<gtExample>
	<return: #GtCSSCoderModel>
	| aCoder |
	aCoder := GtPharoMethodCoder forMethod: self cssMethod.
	self assert: aCoder class equals: GtCSSCoderModel.
	^ aCoder
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> cssCoderViewModel [
	<gtExample>
	<return: #GtCSSCoderViewModel>
	^ self cssCoder asCoderViewModel
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> cssMethod [
	"A method with a <cssString> pragma that returns CSS code."

	<gtExample>
	<return: #CompiledMethod>
	^ GtCSSFileSamples >> #lepiter_common
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> editorWithCSS [
	"The editor shows the CSS code, not the source of the method."

	<gtExample>
	<return: #GtTextEditorElement>
	| anEditor |
	anEditor := GtTextEditorElement new.
	anEditor text: self cssCoderViewModel sourceText asString asRopedText.
	^ anEditor
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> installedController [
	"All selectors le-nav-link are renamed together, the intervals are in the CSS code."

	<gtExample>
	<return: #GtPharoRenameCSSSelectorCoderController>
	| aController aModel aSource |
	aController := self newInstalledController.
	aModel := aController variableModel.
	aSource := self cssCoderViewModel sourceText asString.

	self assert: aModel originalName equals: 'le-nav-link'.
	self assert: aModel originalIntervals size > 1.
	aModel originalIntervals
		do: [ :eachInterval | 
			self
				assert: (aSource copyFrom: eachInterval first to: eachInterval last)
				equals: 'le-nav-link' ].
	"the editor, all other occurrences, and the refactorings preview"
	self assert: aController attributeTags size equals: aModel originalIntervals size + 1.
	^ aController
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> installedController_cancel [
	<gtExample>
	<return: #GtPharoRenameCSSSelectorCoderController>
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
GtPharoRenameCSSSelectorCoderControllerExamples >> installedController_refactorings [
	"The refactoring is only applied to the refactoring model, the CSS methods in the image are not changed. Same as {{gtMethod:GtCSSFileSamples>>#renameCSSSelector}}."

	<gtExample>
	<return: #GtPharoRenameCSSSelectorCoderController>
	| aController aModel someRefactorings aModelClass |
	aController := self newInstalledController.
	aModel := aController variableModel.
	self assert: aController computeRefactorings isEmpty.

	aModel updateCurrentName: 'a12345a' source: self.
	someRefactorings := aController computeRefactorings.
	self assert: someRefactorings size equals: 1.
	self assert: someRefactorings first class equals: GtCSSStringRenameSelectorRefactoring.

	someRefactorings first primitiveExecute.
	aModelClass := someRefactorings first model classFor: GtCSSFileSamples.
	#(writeOn: lepiter_common)
		do: [ :eachSelector | 
			self
				assert: (aModelClass sourceCodeFor: eachSelector)
				equals: ((GtCSSFileSamples sourceCodeAt: eachSelector)
						copyReplaceAll: 'le-nav-link'
						with: 'a12345a') ].
	self
		assert: ((GtCSSFileSamples sourceCodeAt: #lepiter_common) includesSubstring: 'le-nav-link').
	^ aController
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> installedController_validation [
	<gtExample>
	<return: #GtPharoRenameCSSSelectorCoderController>
	| aModel |
	aModel := self newInstalledController variableModel.

	aModel updateCurrentName: 'a12345' source: self.
	self assert: aModel isValid.
	aModel updateCurrentName: '1abc' source: self.
	self assert: aModel isValid not.
	aModel updateCurrentName: 'le nav' source: self.
	self assert: aModel isValid not.
	^ self newInstalledController
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> newInstalledController [
	<gtExample>
	<return: #GtPharoRenameCSSSelectorCoderController>
	^ GtPharoRenameCSSSelectorCoderController new
		originalNode: self selectorNode;
		documentId: nil;
		editorElement: self editorWithCSS;
		sourceCoderViewModel: self cssCoderViewModel;
		install
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> renameSelectorWithNewImplementation [
	"The setting selects the attribute based controller, as the context menu item of the CSS coder does."

	<gtExample>
	<return: #GtTextEditorElement>
	| anEditor |
	anEditor := self editorWithCSS.
	self
		withNewRenameImplementation: true
		do: [ self cssCoder
				renameCSSSelectorChoosingImplementation: self selectorNode
				in: self cssCoderViewModel
				documentId: nil
				for: anEditor ].
	self
		assert: (anEditor userData at: #variableController) class
		equals: GtPharoRenameCSSSelectorCoderController.
	^ anEditor
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> renameSelectorWithOldImplementation [
	<gtExample>
	<return: #GtTextEditorElement>
	| anEditor |
	anEditor := self editorWithCSS.
	self
		withNewRenameImplementation: false
		do: [ self cssCoder
				renameCSSSelectorChoosingImplementation: self selectorNode
				in: self cssCoderViewModel
				documentId: nil
				for: anEditor ].
	self assert: (anEditor userData includesKey: #variableController) not.
	^ anEditor
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> selectorNode [
	"The first selector le-nav-link."

	<gtExample>
	<return: #CSSIdentifierNode>
	self cssCoder astSync
		allNodesOfType: CSSIdentifierNode
		do: [ :each | 
			(each source = 'le-nav-link'
				and: [ (each parent isKindOf: CSSRulesetNode)
						and: [ each parent selectorParts identityIncludes: each ] ]) ifTrue: [ ^ each ] ].
	^ self error: 'The selector le-nav-link must exist'
]

{ #category : #examples }
GtPharoRenameCSSSelectorCoderControllerExamples >> withNewRenameImplementation: aBoolean do: aBlock [
	| aPreviousValue |
	aPreviousValue := GtPharoCoderSettings displayNewRenameImplementationContextMenuItem.
	^ [ GtPharoCoderSettings displayNewRenameImplementationContextMenuItem: aBoolean.
		aBlock value ]
		ensure: [ GtPharoCoderSettings
				displayNewRenameImplementationContextMenuItem: aPreviousValue ]
]
