Class {
	#name : #GtCSSStringSplitRulesetRefactoring,
	#superclass : #RBMethodRefactoring,
	#instVars : [
		'selector',
		'position'
	],
	#category : #'Gt4CSS-Refactorings'
}

{ #category : #'instance creation' }
GtCSSStringSplitRulesetRefactoring class >> model: aModel splitAt: anInteger inMethod: aSelector forClass: aClass [
	^ self new
		model: aModel;
		position: anInteger;
		selector: aSelector;
		methodClass: aClass;
		yourself
]

{ #category : #'instance creation' }
GtCSSStringSplitRulesetRefactoring class >> splitAt: anInteger inMethod: aSelector forClass: aClass [
	^ self new
		position: anInteger;
		selector: aSelector;
		methodClass: aClass;
		yourself
]

{ #category : #transforming }
GtCSSStringSplitRulesetRefactoring >> basicTransform [
	| rewriter method |
	rewriter := RBParseTreeRewriter new.
	rewriter
		replace: '^ `#s `{:node | node value isString}'
		withValueFrom: [ :node | 
			RBReturnNode
				value: (RBLiteralValueNode value: (self splitSource: node value value)) ].
	method := class methodFor: selector.
	((rewriter executeTree: method ast) and: [ method ast ~= rewriter tree ])
		ifTrue: [ method compileTree: rewriter tree ]
		ifFalse: [ self refactoringError: 'Could not split ruleset' ]
]

{ #category : #initialization }
GtCSSStringSplitRulesetRefactoring >> methodClass: aClass [
	class := self model classFor: aClass
]

{ #category : #initialization }
GtCSSStringSplitRulesetRefactoring >> position: anObject [
	position := anObject
]

{ #category : #preconditions }
GtCSSStringSplitRulesetRefactoring >> preconditions [
	^ RBCondition definesSelector: selector in: class
]

{ #category : #transforming }
GtCSSStringSplitRulesetRefactoring >> privateTranform [
	self basicTransform
]

{ #category : #initialization }
GtCSSStringSplitRulesetRefactoring >> selector: anObject [
	selector := anObject
]

{ #category : #transforming }
GtCSSStringSplitRulesetRefactoring >> splitSource: source [
	| string ast |
	string := SmaCCString on: source.
	ast := CSSParser parseWithErrors: source.
	ast
		allNodesOfType: CSSRulesetNode
		do: [ :node | 
			node selectorParts
				doWithIndex: [ :each :i | 
					(each source = ',' and: [ each startPosition = position ])
						ifTrue: [ | ws |
							ws := string whitespaceBeforeIndex: node startPosition.
							((ws includes: Character cr) or: [ ws includes: Character lf ])
								ifFalse: [ ws := String lf , ws ].
							string
								replaceFrom: position
								to: position
								with: (string whitespaceBeforeIndex: node leftBrace startPosition)
										, (string copyFrom: node leftBrace startPosition to: node rightBrace stopPosition)
												asString.
							string insert: ws at: (node selectorParts at: i + 1) startPosition.
							^ string asString ] ] ].
	^ self refactoringError: 'Could not find node to split'
]

{ #category : #transforming }
GtCSSStringSplitRulesetRefactoring >> transform [
	self basicTransform
]
