Class {
	#name : #GtCSSSplitRulesetRefactoringExamples,
	#superclass : #Object,
	#category : #'Gt4CSS-Examples'
}

{ #category : #samples }
GtCSSSplitRulesetRefactoringExamples >> css [
	<cssString>
	^ 'h1, h2 
{
	color: #aaa
}'
]

{ #category : #examples }
GtCSSSplitRulesetRefactoringExamples >> failMissingMethod [
	<gtExample>
	| refactoring |
	refactoring := GtCSSStringSplitRulesetRefactoring
			splitAt: 3
			inMethod: #foo
			forClass: self class.
	[ refactoring primitiveExecute ]
		on: RBRefactoringError
		do: [ :ex | ^ ex copy freeze ].
	self error: 'Refactoring did not throw an error'
]

{ #category : #examples }
GtCSSSplitRulesetRefactoringExamples >> splitRuleset [
	<gtExample>
	| refactoring |
	refactoring := GtCSSStringSplitRulesetRefactoring
			splitAt: 3
			inMethod: #css
			forClass: self class.
	refactoring primitiveExecute.
	self
		assert: ((refactoring model classFor: self class) sourceCodeFor: #css)
		equals: 'css
	<cssString>
	^ ''h1 
{
	color: #aaa
} 
h2 
{
	color: #aaa
}'''.
	^ refactoring model
]
