Class {
	#name : #GtCSSCoderModel,
	#superclass : #GtSourceCoder,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'Gt4CSS-Model'
}

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

{ #category : #initialization }
GtCSSCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

	addOns
		addStyler: (GtCoderAstSmaCCParserStyler new smaccStyler: CSSParser gtStyler)
]

{ #category : #'as yet unclassified' }
GtCSSCoderModel >> initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel [
	super initializeAddOns: addOns viewModel: aGtPharoMethodCoderViewModel.

	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :aCoderUIModel :anElement | aCoderUIModel save ]
		id: GtMethodCoderSaveActionId
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
