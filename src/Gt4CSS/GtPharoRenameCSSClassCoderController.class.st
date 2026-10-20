"
I rename a CSS class that is a string argument of a `style:` message in a Pharo method, e.g., in {{gtMethod:GtCSSFileSamples>>#writeOn:}}. All equal strings in the method are renamed together, the refactoring {{gtClass:GtCSSStringRenameSelectorRefactoring}} renames the CSS class in all methods and CSS strings, see {{gtClass:GtPharoRenameCSSClassRefactoringsStencil}}. The new name must be a CSS class name, see {{gtClass:GtPharoRenameCSSClassValidator}}. I replace {{gtClass:GtCSSStringRenameSelectorController}} for Pharo methods, the old controller is still used for CSS coders. See {{gtMethod:GtPharoSourceCoder>>#renameCSSClassChoosingImplementation:in:for:}}.

"
Class {
	#name : #GtPharoRenameCSSClassCoderController,
	#superclass : #GtPharoRenameLiteralCoderController,
	#category : #'Gt4CSS-Refactorings - New'
}

{ #category : #accessing }
GtPharoRenameCSSClassCoderController >> createRefactoringsStencil [
	^ GtPharoRenameCSSClassRefactoringsStencil new
]

{ #category : #accessing }
GtPharoRenameCSSClassCoderController >> createValidator [
	^ GtPharoRenameCSSClassValidator new
]

{ #category : #accessing }
GtPharoRenameCSSClassCoderController >> refactoringName [
	^ 'Rename CSS class'
]
