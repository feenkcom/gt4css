Class {
	#name : #GtCSSStringRenameSelectorRefactoring,
	#superclass : #RBMethodRefactoring,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'Gt4CSS-Refactorings'
}

{ #category : #'instance creation' }
GtCSSStringRenameSelectorRefactoring class >> model: aRBNamespace rename: oldName to: newName [
	^ self new
		model: aRBNamespace;
		oldName: oldName;
		newName: newName;
		yourself
]

{ #category : #'instance creation' }
GtCSSStringRenameSelectorRefactoring class >> rename: oldName to: newName [
	^ self new
		oldName: oldName;
		newName: newName;
		yourself
]

{ #category : #transforming }
GtCSSStringRenameSelectorRefactoring >> basicTransform [
	self renameDefinitions.
	self renameUsages
]

{ #category : #accessing }
GtCSSStringRenameSelectorRefactoring >> newName [
	^ newName
]

{ #category : #accessing }
GtCSSStringRenameSelectorRefactoring >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtCSSStringRenameSelectorRefactoring >> oldName [
	^ oldName
]

{ #category : #accessing }
GtCSSStringRenameSelectorRefactoring >> oldName: anObject [
	oldName := anObject
]

{ #category : #transforming }
GtCSSStringRenameSelectorRefactoring >> potentialUsagesDo: aBlock [
	| methods |
	methods := IdentitySet new.
	(self model selectorsWithKeyword: 'style:')
		do: [ :sel | 
			self model
				allReferencesTo: sel asSymbol
				do: [ :method | 
					(methods includes: method)
						ifFalse: [ aBlock value: method.
							methods add: method ] ] ]
]

{ #category : #preconditions }
GtCSSStringRenameSelectorRefactoring >> preconditions [
	^ RBCondition withBlock: [ true ]
]

{ #category : #transforming }
GtCSSStringRenameSelectorRefactoring >> privateTransform [
	self basicTransform
]

{ #category : #transforming }
GtCSSStringRenameSelectorRefactoring >> renameDefinitions [
	| rewriter |
	rewriter := RBParseTreeRewriter new.
	rewriter
		replace: '^ `#s `{:node | node value isString}'
		withValueFrom: [ :node | 
			| ast string |
			ast := CSSParser parseWithErrors: node value value.
			string := SmaCCString on: node value value.
			ast
				allNodesOfType: CSSIdentifierNode
				do: [ :id | 
					(id name source = oldName
						and: [ (id parent isKindOf: CSSRulesetNode)
								and: [ id parent selectorParts identityIncludes: id ] ])
						ifTrue: [ string
								replaceFrom: id startPosition
								to: id stopPosition
								with: newName ] ].
			RBReturnNode value: (RBLiteralValueNode value: string asString) ].
	self model
		allMethodsWithPragma: #cssString
		do: [ :method | 
			((rewriter executeTree: method ast) and: [ method ast ~= rewriter tree ])
				ifTrue: [ method compileTree: rewriter tree ] ]
]

{ #category : #transforming }
GtCSSStringRenameSelectorRefactoring >> renameUsages [
	| rewriter |
	rewriter := RBParseTreeRewriter new.
	rewriter
		replace: oldName printString
				, ' `{:node | 
					node parent isMessage and: [ 
						| index |
						index := node parent arguments identityIndexOf: node.
						index > 0 
							and: [(node parent selectorParts at: index) = ''style:'' ] ] }'
		with: newName printString.
	self
		potentialUsagesDo: [ :method | (rewriter executeTree: method ast) ifTrue: [ method compileTree: rewriter tree ] ]
]

{ #category : #transforming }
GtCSSStringRenameSelectorRefactoring >> transform [
	self basicTransform
]
