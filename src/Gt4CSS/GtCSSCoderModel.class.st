Class {
	#name : #GtCSSCoderModel,
	#superclass : #GtSourceCoder,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'Gt4CSS-Model'
}

{ #category : #'instance creation' }
GtCSSCoderModel class >> forMethod: aCompiledMethod in: behavior [
	^ self new forMethod: aCompiledMethod
]

{ #category : #adding }
GtCSSCoderModel >> addContextMenuAddOns: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 10>
	| allSelections allCursors node interval group |
	group := BrMenuItemGroupConfiguration new
			name: 'CSS';
			priority: 10.
	allSelections := aCoderViewModel selection allSelections.
	allCursors := aCoderViewModel cursors allCursors.
	interval := allSelections size = 1
			ifTrue: [ allSelections first indices ]
			ifFalse: [ allCursors size = 1
					ifTrue: [ allCursors first position to: allCursors first position ]
					ifFalse: [ ^ self ] ].
	node := anAst nodeForInterval: interval.

	(node isKindOf: CSSDeclarationNode)
		ifTrue: [ (node name startPosition <= interval first
				and: [ node name stopPosition >= interval last ])
				ifTrue: [ coderAddOns
						addContextMenuItem: (self
								createLabel: 'References to property'
								description: node name source)
						group: group
						hover: nil
						leave: nil
						action: [ :aTextualViewModel :element | element phlow spawnObject: node name source gtCSSStringPropertyReferences ]
						id: #'context-menu--css-property-reference' ].
			^ self ].

	((node isKindOf: CSSIdentifierNode)
		and: [ (node parent isKindOf: CSSRulesetNode)
				and: [ (node parent selectorParts identityIncludes: node)
						and: [ node startPosition <= interval first
								and: [ node stopPosition >= interval last ] ] ] ])
		ifTrue: [ coderAddOns
				addContextMenuItem: (self
						createLabel: 'Rename CSS class'
						description: node source)
				group: (BrMenuItemGroupConfiguration new
						name: 'Refactoring';
						priority: 5)
				hover: nil
				leave: nil
				action: [ :cvm :element | 
					(GtCSSStringRenameSelectorController new
						sourceCoderViewModel: cvm;
						originalNode: node) executeIn: element ]
				id: #'context-menu--css-rename-selector'.
			coderAddOns
				addContextMenuItem: (self
						createLabel: 'References in methods'
						description: node source)
				group: group
				hover: nil
				leave: nil
				action: [ :aTextualViewModel :element | element phlow spawnObject: node name source gtCSSClassMethodReferences ]
				id: #'context-menu--css-method-reference'.
			coderAddOns
				addContextMenuItem: (self
						createLabel: 'References in css'
						description: node source)
				group: group
				hover: nil
				leave: nil
				action: [ :aTextualViewModel :element | element phlow spawnObject: node name source gtCSSStringSelectorReferences ]
				id: #'context-menu--css-string-reference'.
			^ self ].

	(node isKindOf: CSSDelimiterNode) ifTrue: [ node := node parent ].

	(node isKindOf: CSSRulesetNode)
		ifTrue: [ node selectorParts
				doWithIndex: [ :each :i | 
					((each isKindOf: CSSDelimiterNode)
						and: [ (node selectorParts at: i - 1) stopPosition <= interval first
								and: [ (node selectorParts at: i + 1) startPosition > interval last ] ])
						ifTrue: [ coderAddOns
								addContextMenuItem: (self
										createLabel: 'Split ruleset'
										description: node source)
								group: (BrMenuItemGroupConfiguration new
										name: 'Refactoring';
										priority: 5)
								hover: nil
								leave: nil
								action: [ :cvm :element | 
									((GtCSSStringSplitRulesetRefactoringController new sourceCoderViewModel: cvm)
										position: each startPosition) executeIn: element ]
								id: #'context-menu--css-split-ruleset' ] ] ]
]

{ #category : #converting }
GtCSSCoderModel >> asCoderViewModel [
	^ GtCSSCoderViewModel new
		coder: self;
		yourself
]

{ #category : #accessing }
GtCSSCoderModel >> behavior [
	^ self methodBehavior behavior
]

{ #category : #'as yet unclassified' }
GtCSSCoderModel >> collapsedText [
	^selector asRopedText
]

{ #category : #accessing }
GtCSSCoderModel >> compiledMethod [
	^ self behavior >> self selector
]

{ #category : #'api - ast' }
GtCSSCoderModel >> computeAst: aString [
	^ CSSParser parseWithErrors: aString
]

{ #category : #accessing }
GtCSSCoderModel >> example [
	^nil
]

{ #category : #'instance creation' }
GtCSSCoderModel >> forMethod: aCompiledMethod [
	| source |
	self
		methodBehavior: (GtPharoCoderBehavior explicit: aCompiledMethod methodClass).
	self selector: aCompiledMethod selector.
	source := (aCompiledMethod methodClass isInstanceSide
			ifTrue: [ aCompiledMethod methodClass new ]
			ifFalse: [ aCompiledMethod methodClass instanceSide ])
			perform: aCompiledMethod selector.
	self sourceCode: (GtCoderExplicitStringSource new source: source)
]

{ #category : #ui }
GtCSSCoderModel >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live' translated;
		priority: 10;
		object: [ self ];
		view: #gtLiveFor:context:
]

{ #category : #views }
GtCSSCoderModel >> gtLiveFor: aView context: aContext [
	<gtView>
	| lspModel |
	lspModel := aContext at: #cssLSPModel ifAbsentPut: [ GtLSPCSSModel local ].
	^ aView explicit
		title: 'Live';
		priority: 5;
		stencil: [ self asElement
				vFitContentLimited;
				lspModel: lspModel;
				yourself ]
]

{ #category : #accessing }
GtCSSCoderModel >> highlighter [
	^ self attributeNamed: #highlighter
]

{ #category : #accessing }
GtCSSCoderModel >> highlighter: aHighlighter [
	self highlighter == aHighlighter ifTrue: [ ^ self ].

	self attributeNamed: #highlighter put: aHighlighter.

	self requestUpdateAddOns
]

{ #category : #'add-ons' }
GtCSSCoderModel >> highlighterFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	self highlighter
		ifNotNil: [ :aHighlighter | coderAddOns addStyler: aHighlighter ]
]

{ #category : #initialization }
GtCSSCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

	addOns
		addStyler: (GtCoderAstSmaCCParserStyler new smaccStyler: CSSParser gtStyler)
]

{ #category : #initialization }
GtCSSCoderModel >> initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel [
	super initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel.

	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :aCoderUIModel :anElement | aCoderUIModel save ]
		id: GtMethodCoderSaveActionId.
	addOns
		addMainAction: 'Inspect Method' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :aCoderUIModel :anElement | 
			self
				notifyObjectSpawn: (aCoderUIModel behavior >> aCoderUIModel selector) methodReference
				requesterObject: aCoderUIModel ]
		id: GtMethodCoderInspectActionId.
	self initializeSearchTextAddOns: addOns viewModel: aGtPharoMethodCoderViewModel
]

{ #category : #initialization }
GtCSSCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns addShortcut: GtSourceCoderSaveShortcut new
]

{ #category : #testing }
GtCSSCoderModel >> isForMethod [
	^ false
]

{ #category : #testing }
GtCSSCoderModel >> isMeta [
	"Return true if the method is implemented in a pharo metaclass (~ class side)"

	<return: #Boolean>
	^ self behavior isMeta
]

{ #category : #accessing }
GtCSSCoderModel >> methodBehavior [
	^ methodBehavior
]

{ #category : #accessing }
GtCSSCoderModel >> methodBehavior: anObject [
	methodBehavior := anObject
]

{ #category : #'method generation' }
GtCSSCoderModel >> methodSource [
	^ String
		streamContents: [ :stream | 
			stream
				<< self selector;
				cr;
				<< '	<cssString>';
				cr;
				<< '	^ ''';
				<< (self currentSourceString copyReplaceAll: '''' with: '''''');
				<< '''' ]
]

{ #category : #'add-ons' }
GtCSSCoderModel >> modifiedMessageAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 2>

	self isModified
		ifFalse: [ ^ self ].

	coderAddOns
		addMainAction: 'Discard Changes' translated
		icon: BrGlamorousVectorIcons cancel
		action: [ :aCoderUIModel :anElement | aCoderUIModel discardChanges ]
		id: GtMethodCoderDiscardChangesActionId
]

{ #category : #subscriptions }
GtCSSCoderModel >> onMethodModified: aMethodModified [
	| doesAffect |
	doesAffect := self methodBehavior
			realBehaviorDo: [ :aBehavior | 
				aMethodModified classAffected = aBehavior
					and: [ aMethodModified oldMethod selector = self selector
							or: [ aMethodModified newMethod selector = self selector ] ] ]
			ifAbsent: [ self methodBehavior
					behaviorNameDo: [ :aBehaviorName | 
						aMethodModified classAffected name = aBehaviorName
							and: [ aMethodModified oldMethod selector = self selector
									or: [ aMethodModified newMethod selector = self selector ] ] ]
					ifAbsent: [ false ] ].

	doesAffect ifFalse: [ ^ self ].

	(aMethodModified newMethod pragmas
		anySatisfy: [ :each | each selector = #cssString ]) ifFalse: [ ^ self ].

	self forMethod: aMethodModified newMethod
]

{ #category : #accessing }
GtCSSCoderModel >> package [
	^ self compiledMethod package
]

{ #category : #'private - actions' }
GtCSSCoderModel >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Nothing to evaluate"
]

{ #category : #'private - actions' }
GtCSSCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Nothing to evaluate"
]

{ #category : #accessing }
GtCSSCoderModel >> protocol [
	^ (self methodBehavior behavior methodNamed: self selector) protocol
]

{ #category : #accessing }
GtCSSCoderModel >> save [
	self methodBehavior
		realBehaviorDo: [ :cls | 
			| model method |
			model := GtRBNamespace new.
			((model classFor: cls) methodFor: self selector)
				compileTree: (RBParser parseMethod: self methodSource).
			GtPharoCodeModifier current performRefactoryChange: model changes.
			method := cls >> self selector.
			self forMethod: method.
			^ true ].
	^ false
]

{ #category : #accessing }
GtCSSCoderModel >> selector [
	^ selector
]

{ #category : #accessing }
GtCSSCoderModel >> selector: anObject [
	selector := anObject
]

{ #category : #subscriptions }
GtCSSCoderModel >> subscribeToSystem [
	self unsubscribeFromSystem.

	SystemAnnouncer uniqueInstance weak
		when: MethodModified
		send: #onMethodModified:
		to: self
]

{ #category : #'as yet unclassified' }
GtCSSCoderModel >> testCase [
	^nil
]

{ #category : #subscriptions }
GtCSSCoderModel >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
