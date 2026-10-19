"
I accept a non-empty name of letters, digits, hyphens and underscores that does not start with a digit. See {{gtClass:GtPharoRenameCSSClassCoderController}}.
"
Class {
	#name : #GtPharoRenameCSSClassValidator,
	#superclass : #GtPharoRenameVariableValidator,
	#category : #'Gt4CSS-Refactorings - New'
}

{ #category : #accessing }
GtPharoRenameCSSClassValidator >> validateVariableName: aString [
	"A CSS class name consists of letters, digits, hyphens and underscores, and does not start with a digit."

	aString isEmpty ifTrue: [ ^ false ].
	aString first isDigit ifTrue: [ ^ false ].
	^ aString
		allSatisfy: [ :each | each isLetter or: [ each isDigit or: [ '-_' includes: each ] ] ]
]
