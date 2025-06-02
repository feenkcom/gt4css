Extension { #name : #Class }

{ #category : #'*Gt4CSS' }
Class >> gtCSSScripts [
	^ (Pragma allNamed: 'cssString')
		select: [ :each | 
			each method numArgs = 0
				and: [ each method gtIsActive
						and: [ each method methodClass = self instanceSide
								or: [ each method methodClass = self classSide ] ] ] ]
]

{ #category : #'*Gt4CSS' }
Class >> gtCSSStringsFor: aView context: aDictionary [
	<gtClassView>
	| scripts lspModel |
	scripts := self gtCSSScripts.
	scripts isEmpty ifTrue: [ ^ aView empty ].
	lspModel := aDictionary at: #cssLSPModel ifAbsentPut: [ GtLSPCSSModel local ].
	^ aView forward
		title: 'CSS strings';
		priority: 20;
		object: [ GtCSSStringClassFilter forClass: self ];
		view: #gtItemsFor:
]
