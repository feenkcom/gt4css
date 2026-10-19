"
I create {{gtClass:GtCSSStringRenameSelectorRefactoring}} that renames a CSS class. Unlike {{gtClass:GtPharoRenameLiteralRefactoringsStencil}} I do not compile the coder source into the model, because the source of a CSS coder is CSS code. See {{gtClass:GtPharoRenameCSSSelectorCoderController}}.
"
Class {
	#name : #GtPharoRenameCSSSelectorRefactoringsStencil,
	#superclass : #GtPharoRenameVariableRefactoringsStencil,
	#category : #Gt4CSS
}

{ #category : #accessing }
GtPharoRenameCSSSelectorRefactoringsStencil >> computeRefactoring [
	"Same as {{gtMethod:GtCSSStringRenameSelectorController>>#rename:to:}}."

	^ GtCSSStringRenameSelectorRefactoring
		model: self createModel
		rename: variableModel originalName
		to: variableModel currentName
]

{ #category : #accessing }
GtPharoRenameCSSSelectorRefactoringsStencil >> createModel [
	"The source of a CSS coder is CSS code, not the source of the method, so it is never compiled into the model. The refactoring rewrites the CSS strings of the methods itself."

	| aModel |
	aModel := GtRBNamespace onEnvironment: RBBrowserEnvironment new.
	aModel name: self refactoringName.
	^ aModel
]

{ #category : #accessing }
GtPharoRenameCSSSelectorRefactoringsStencil >> refactoringName [
	^ 'Rename CSS class'
]
