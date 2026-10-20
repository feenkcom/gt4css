"
I rename a CSS class (a selector) in a CSS coder, i.e., a coder of a method with the `<cssString>` pragma, e.g., `le-nav-link` in {{gtMethod:GtCSSFileSamples>>#lepiter_common}}. The text of the coder is the CSS code returned by the method. All equal selectors in the CSS code are renamed together, the refactoring {{gtClass:GtCSSStringRenameSelectorRefactoring}} renames the CSS class in all CSS methods and `style:` usages, see {{gtClass:GtPharoRenameCSSSelectorRefactoringsStencil}}. The new name must be a CSS class name, see {{gtClass:GtPharoRenameCSSClassValidator}}. I replace {{gtClass:GtCSSStringRenameSelectorController}} for CSS coders. See {{gtMethod:GtCSSCoderModel>>#renameCSSSelectorChoosingImplementation:in:documentId:for:}}. For `style:` strings in Pharo methods see {{gtClass:GtPharoRenameCSSClassCoderController}}.
"
Class {
	#name : #GtPharoRenameCSSSelectorCoderController,
	#superclass : #GtPharoRenameVariableCoderController,
	#category : #Gt4CSS
}

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> createRefactoringsStencil [
	^ GtPharoRenameCSSSelectorRefactoringsStencil new
]

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> createValidator [
	^ GtPharoRenameCSSClassValidator new
]

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> isSelectorIdentifier: aNode [
	"The same nodes are renamed by {{gtMethod:GtCSSStringRenameSelectorRefactoring>>#renameDefinitions}}."

	^ (aNode parent isKindOf: CSSRulesetNode)
		and: [ aNode parent selectorParts identityIncludes: aNode ]
]

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> originalName [
	^ originalNode source
]

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> otherRenameIntervals [
	"Intervals of all other selectors with the same name in the CSS code."

	| someIntervals |
	someIntervals := OrderedCollection new.
	originalNode topParent
		allNodesOfType: CSSIdentifierNode
		do: [ :each | 
			(each ~~ originalNode
				and: [ each source = originalNode source and: [ self isSelectorIdentifier: each ] ])
				ifTrue: [ someIntervals add: (each startPosition to: each stopPosition) ] ].
	^ someIntervals
]

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> primaryRenameInterval [
	^ originalNode startPosition to: originalNode stopPosition
]

{ #category : #accessing }
GtPharoRenameCSSSelectorCoderController >> refactoringName [
	^ 'Rename CSS class'
]
