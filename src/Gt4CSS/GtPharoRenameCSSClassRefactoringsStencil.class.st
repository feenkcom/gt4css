"
I create {{gtClass:GtCSSStringRenameSelectorRefactoring}} that renames a CSS class. See {{gtClass:GtPharoRenameCSSClassCoderController}}.
"
Class {
	#name : #GtPharoRenameCSSClassRefactoringsStencil,
	#superclass : #GtPharoRenameLiteralRefactoringsStencil,
	#category : #'Gt4CSS-Refactorings - New'
}

{ #category : #accessing }
GtPharoRenameCSSClassRefactoringsStencil >> computeRefactoring [
	"Same as {{gtMethod:GtCSSStringRenameSelectorController>>#rename:to:}}."

	^ GtCSSStringRenameSelectorRefactoring
		model: self createModel
		rename: variableModel originalName
		to: variableModel currentName
]

{ #category : #accessing }
GtPharoRenameCSSClassRefactoringsStencil >> refactoringName [
	^ 'Rename CSS class'
]
