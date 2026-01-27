Class {
	#name : #GtCSSStringRenameSelectorController,
	#superclass : #GtRenameLiteralItemController,
	#category : 'Gt4CSS-Refactorings'
}

{ #category : #accessing }
GtCSSStringRenameSelectorController >> installValidation [
	renameAction forText
]

{ #category : #'as yet unclassified' }
GtCSSStringRenameSelectorController >> intervalForNode: aNode [
	| source hasQuotes |
	source := aNode source.
	hasQuotes := source last = $'.
	^ aNode startPosition
		+ (hasQuotes ifTrue: [ source indexOf: $' ] ifFalse: [ 0 ])
		to: aNode stopPosition - (hasQuotes ifTrue: [ 1 ] ifFalse: [ 0 ])
]

{ #category : #accessing }
GtCSSStringRenameSelectorController >> originalName [
	^ (self originalNode isKindOf: GtPharoLiteralNode)
		ifTrue: [ super originalName ]
		ifFalse: [ self originalNode source ]
]

{ #category : #accessing }
GtCSSStringRenameSelectorController >> refactoringName [
	^ 'Rename CSS class'
]

{ #category : #accessing }
GtCSSStringRenameSelectorController >> rename: anOldName to: aNewName [
	| aModel |
	aModel := self createModel.
	^ GtCSSStringRenameSelectorRefactoring
		model: aModel
		rename: anOldName
		to: aNewName
]
