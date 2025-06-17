Class {
	#name : #GtCSSStringSplitRulesetRefactoringController,
	#superclass : #GtPharoSourceCoderRefactoringController,
	#instVars : [
		'position'
	],
	#category : #'Gt4CSS-Refactorings'
}

{ #category : #'as yet unclassified' }
GtCSSStringSplitRulesetRefactoringController >> createRefactoringModel [
	| model class source |
	class := sourceCoderViewModel behavior.
	source := sourceCoderViewModel coderModel methodSource.
	model := Smalltalk createRbNamespace
			onEnvironment: RBBrowserEnvironment new.
	(model classFor: class) compile: source classified: #accessing.
	model name: self refactoringName.
	^ model
]

{ #category : #accessing }
GtCSSStringSplitRulesetRefactoringController >> position [
	^ position
]

{ #category : #accessing }
GtCSSStringSplitRulesetRefactoringController >> position: anObject [
	position := anObject
]

{ #category : #accessing }
GtCSSStringSplitRulesetRefactoringController >> refactoring [
	| model |
	model := self createRefactoringModel.
	^ GtCSSStringSplitRulesetRefactoring
		model: model
		splitAt: position
		inMethod: sourceCoderViewModel selector
		forClass: (model classFor: sourceCoderViewModel behavior)
]

{ #category : #accessing }
GtCSSStringSplitRulesetRefactoringController >> refactoringName [
	^ 'Split ruleset'
]

{ #category : #executing }
GtCSSStringSplitRulesetRefactoringController >> safelyExecute [
	| refactoring newSource methodSource |
	refactoring := self refactoring.
	sourceCoderViewModel selectNone.
	[ refactoring primitiveExecute ] on: RBRefactoringError do: [ :ex | ^ self ].
	methodSource := (refactoring model classFor: sourceCoderViewModel behavior)
			sourceCodeFor: sourceCoderViewModel selector.
	(GtPharoParser parse: methodSource)
		allNodesOfType: GtPharoStringLiteralNode
		do: [ :node | newSource := node literalValue ].
	sourceCoderViewModel sourceText asString = newSource
		ifFalse: [ self setText: newSource asText ]
]
