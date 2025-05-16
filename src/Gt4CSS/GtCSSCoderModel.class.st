Class {
	#name : #GtCSSCoderModel,
	#superclass : #GtSourceCoder,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'Gt4CSS-Model'
}

{ #category : #'as yet unclassified' }
GtCSSCoderModel >> addContextMenuAddOns: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 10>
	| allSelections allCursors node interval |
	allSelections := aCoderViewModel selection allSelections.
	allCursors := aCoderViewModel cursors allCursors.
	interval := allSelections size = 1
			ifTrue: [ allSelections first ]
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
						group: (BrMenuItemGroupConfiguration new
								name: 'CSS';
								priority: 10)
						hover: nil
						leave: nil
						action: [ :aTextualViewModel :element | element phlow spawnObject: node name source gtCSSStringPropertyReferences ] ].
			^ self ].

	((node isKindOf: CSSIdentifierNode)
		and: [ (node parent isKindOf: CSSRulesetNode)
				and: [ (node parent selectorParts identityIncludes: node)
						and: [ node startPosition <= interval first
								and: [ node stopPosition >= interval last ] ] ] ])
		ifTrue: [ coderAddOns
				addContextMenuItem: (self
						createLabel: 'References in methods'
						description: node source)
				group: (BrMenuItemGroupConfiguration new
						name: 'CSS';
						priority: 10)
				hover: nil
				leave: nil
				action: [ :aTextualViewModel :element | element phlow spawnObject: node name source gtCSSClassMethodReferences ].
			coderAddOns
				addContextMenuItem: (self
						createLabel: 'References in css'
						description: node source)
				group: (BrMenuItemGroupConfiguration new
						name: 'CSS';
						priority: 10)
				hover: nil
				leave: nil
				action: [ :aTextualViewModel :element | element phlow spawnObject: node name source gtCSSStringSelectorReferences ].
			^ self ]
]

{ #category : #converting }
GtCSSCoderModel >> asCoderViewModel [
	^ GtCSSCoderViewModel new coder: self
]

{ #category : #'api - ast' }
GtCSSCoderModel >> computeAst: aString [
	^ CSSParser parseWithErrors: aString
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
		id: GtMethodCoderSaveActionId
]

{ #category : #initialization }
GtCSSCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns addShortcut: GtSourceCoderSaveShortcut new
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

{ #category : #'private - actions' }
GtCSSCoderModel >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Nothing to evaluate"
]

{ #category : #'private - actions' }
GtCSSCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Nothing to evaluate"
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
