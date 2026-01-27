Class {
	#name : #CSSPrettyPrinterVisitor,
	#superclass : #Object,
	#traits : 'TCSSProgramNodeVisitor',
	#classTraits : 'TCSSProgramNodeVisitor classTrait',
	#instVars : [
		'stream',
		'indent',
		'allComments'
	],
	#category : 'Gt4CSS-Model'
}

{ #category : #generated }
CSSPrettyPrinterVisitor >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [^nil].
	aSmaCCParseNode commentsBefore do: 
			[:each |
			| comment |
			comment := aSmaCCParseNode completeSource asString copyFrom: each first
						to: each second.
			(allComments remove: each ifAbsent: [nil])
				ifNotNil: 
					[stream
						tab: indent;
						nextPutAll: comment;
						cr]].
	^aSmaCCParseNode acceptVisitor: self
]

{ #category : #public }
CSSPrettyPrinterVisitor >> contents [
	^stream contents
]

{ #category : #'initialize-release' }
CSSPrettyPrinterVisitor >> initialize [
	super initialize.
	stream := String new writeStream.
	indent := 0.
	allComments := OrderedCollection new
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitAtRule: anAtRule [
	self accept: anAtRule atKeyword.
	stream nextPutAll: ' '.
	anAtRule parts do: [:e | self accept: e] separatedBy: [stream space].
	stream nextPutAll: ' '.
	self accept: anAtRule block
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitBlock: aBlock [
	indent := indent + 1.
	stream
		nextPutAll: '{';
		cr.
	stream tab: indent.
	aBlock items do: 
			[:e |
			| end start isNewLine isBlockEnd |
			isBlockEnd := e nodeAfter isNil or: [e nodeAfter parent ~= e parent].
			end := e nodeAfter
						ifNil: [e parent stopPosition]
						ifNotNil: [:after | after startPosition].
			start := e stopPosition.
			isNewLine := end notNil and: 
							[aBlock semicolons
								anySatisfy: [:semicolon | semicolon startPosition between: start and: end]].
			self accept: e.
			(isNewLine not
				and: [e isBlockNode not and: [e nodeAfter notNil and: [end - start > 1]]])
					ifTrue: [stream space].
			(e isBlockNode and: [isBlockEnd not]) ifTrue: [stream tab: indent].
			isNewLine
				ifTrue: 
					[stream nextPutAll: ';'.
					stream cr.
					isBlockEnd ifFalse: [stream tab: indent]]].
	indent := indent - 1.
	stream
		tab: indent;
		nextPutAll: '}';
		cr
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitBracketExpression: aBracketExpression [
	stream nextPutAll: '['.
	self accept: aBracketExpression items.
	stream nextPutAll: ']'
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitCommentDelimiter: aCommentDelimiter [
	^self visitProgram: aCommentDelimiter
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitDeclaration: aDeclaration [
	stream
		tab: indent;
		nextPutAll: aDeclaration name value.
	stream nextPutAll: ': '.
	aDeclaration star ifNotNil: [self error: 'not yet implemented'].
	aDeclaration values do: 
			[:e |
			| end start isLast nodeAfter |
			nodeAfter := e nodeAfter.
			end := nodeAfter
						ifNil: [e parent stopPosition]
						ifNotNil: [:after | after startPosition].
			isLast := nodeAfter isNil or: [nodeAfter parent ~= e parent].
			start := e stopPosition.
			self accept: e.
			(isLast not and: [nodeAfter notNil and: [end - start > 1]]) ifTrue: [stream space]]
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitDelimiter: aDelimiter [
	stream nextPutAll: aDelimiter value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitDimension: aDimension [
	stream nextPutAll: aDimension value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitFunction: aFunction [
	| items |
	stream nextPutAll: aFunction name value.
	items := aFunction items.
	items doWithIndex: 
			[:e :i |
			i > 1
				ifTrue: 
					[(items at: i - 1) stopPosition + 1 = e startPosition ifFalse: [stream space]].
			self accept: e].
	stream nextPutAll: ')'
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitName: aName [
	stream nextPutAll: aName name value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitNumber: aNumber [
	stream nextPutAll: aNumber value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitOperator: anOperator [
	^self visitProgram: anOperator
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitParenthesizedExpression: aParenthesizedExpression [
	stream nextPutAll: '('.
	self accept: aParenthesizedExpression items.
	stream nextPutAll: ')'
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitPercentage: aPercentage [
	stream nextPutAll: aPercentage value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitRuleset: aRuleset [
	| col |
	indent := indent + 1.
	col := aRuleset selectorParts.
	col doWithIndex: 
			[:e :i |
			i > 1
				ifTrue: 
					[(col at: i - 1) stopPosition + 1 = e startPosition ifFalse: [stream space]].
			self accept: e].
	stream
		nextPutAll: ' {';
		cr.
	aRuleset items do: 
			[:e |
			self accept: e.
			stream
				nextPutAll: ';';
				cr].
	stream
		nextPutAll: '}';
		cr.
	indent := indent - 1
]

{ #category : #visiting }
CSSPrettyPrinterVisitor >> visitSmaCCError: aSmaCCError [
	stream nextPutAll: aSmaCCError source
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitString: aString [
	stream nextPutAll: aString value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitStylesheet: aStylesheet [
	allComments := aStylesheet topParent comments copy.
	^ self visitProgram: aStylesheet
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitUnicodeRange: anUnicodeRange [
	stream nextPutAll: anUnicodeRange value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitURI: anURI [
	stream nextPutAll: anURI value value
]

{ #category : #generated }
CSSPrettyPrinterVisitor >> visitValue: aValue [
	^self visitProgram: aValue
]
