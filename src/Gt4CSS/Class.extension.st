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
	^ aView explicit
		title: 'CSS strings';
		priority: 20;
		stencil: [ | list |
			list := BrSimpleList new
					matchParent;
					items: ((scripts asSortedCollection: [ :a :b | a method selector < b method selector ])
							collect: [ :each | (GtCSSCoderModel new forMethod: each method) asCoderViewModel expanded: false ]);
					itemType: [ :factory :each | each elementClass ];
					itemStencil: [ :class | 
						class new
							vFitContentLimited;
							lspModel: lspModel;
							yourself ];
					itemDataBinder: [ :eachCoderElement :eachCoderViewModel | eachCoderElement coderViewModel: eachCoderViewModel ] ]
]
