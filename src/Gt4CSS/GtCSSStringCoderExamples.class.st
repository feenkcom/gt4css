Class {
	#name : #GtCSSStringCoderExamples,
	#superclass : #Object,
	#traits : 'TCoderByScripterExamples',
	#classTraits : 'TCoderByScripterExamples classTrait',
	#instVars : [
		'environment'
	],
	#category : #'Gt4CSS-Examples'
}

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> addMethod [
	<gtExample>
	| scripter |
	scripter := self cssStringCoder.
	self
		check: scripter
		selector: #aaa
		exists: false.
	self cssClass
		compile: 'aaa <cssString> ^''.aaa { color: #888; }'''
		classified: #'css string'.
	self waitForCompile: scripter.
	self
		check: scripter
		selector: #aaa
		exists: true.
	scripter
		clickStep: [ :s | 
			s
				label: 'Click CSS string';
				// GtCSSExpandableSourceCoderElement;
				// BlAttributedTextElement;
				@ [ :each | each text asString = 'aaa' ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> changeProtocol [
	<gtExample>
	| scripter |
	scripter := self expandCSSItem.
	scripter clickStep: [:s | 
		s
			label: 'Click protocol button';
			// GtCSSExpandableSourceCoderElement;
			@ [:each | each isExpanded ];
			// GtPharoProtocolTagId].
	scripter typeStep: [:s | 
		s
				label: 'Fill new protocol';
				text: 'foo'
	].
	scripter
		keyPressStep: [ :s | 
			s
				label: 'Complete name';
				key: BlKeyboardKey return ].
	self 
		assert: (environment anyDummyClass realClass >> #background111) protocolName 
		equals: 'foo'.
		
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> changeToClassSideMethod [
	<gtExample>
	| scripter |
	scripter := self expandCSSItem.
	scripter
		clickStep: [ :s | 
			s
				label: 'Click side button';
				// GtCSSExpandableSourceCoderElement;
				@ [ :each | each isExpanded ];
				// GtPharoSideTagId ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click side button';
				onSpaceRoot;
				onDropdown: true;
				onBrButtonName: 'class' ].
	self
		assert: (environment anyDummyClass realClass selectors includes: #background111) not.
	self
		assert: (environment anyDummyClass realClass class selectors includes: #background111).
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> check: scripter selector: aString exists: aBoolean [
	scripter
		checkStep: [ :s | 
			s
				label: 'Check for ' , aString;
				// GtCSSExpandableSourceCoderElement;
				// BlAttributedTextElement;
				@ [ :each | each text asString = aString ].
			aBoolean ifTrue: [ s exists ] ifFalse: [ s notExists ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> cleanUp [
	environment ifNotNil: [ :anEnvironment | anEnvironment removeFromSystem ]
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> cssClass [
	^ environment anyDummyRootClass realClass
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> cssMethodCoder [
	<gtExample>
	| scripter |
	self generateClassWithCSS.
	scripter := self
			scripterInPagerForBlock: [ GtCoderElement forClass: self cssClass ].
	scripter
		doStep: [ :s | 
			s
				label: 'Set space extent';
				block: [ :aSpace | aSpace extent: 2400 @ 1000 ];
				onSpace ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click Methods tab';
				// #tabbar;
				// BlTextElement;
				@ [ :each | each text asString = 'Methods' ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> cssSourceForIndex: i [
	^ '.background<1s> {
	background: #<1s>;
}'
		expandMacrosWith: (((i printStringRadix: 16) last: 1) repeat: 3)
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> cssStringCoder [
	<gtExample>
	| scripter |
	self generateClassWithCSS.
	scripter := self
			scripterInPagerForBlock: [ GtCoderElement forClass: self cssClass ].
	scripter
		doStep: [ :s | 
			s
				label: 'Set space extent';
				block: [ :aSpace | aSpace extent: 2400 @ 1000 ];
				onSpace ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click CSS string';
				// #tabbar;
				// BlTextElement;
				@ [ :each | each text asString = 'CSS strings' ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> expandCSSItem [
	<gtExample>
	| scripter |
	scripter := self cssStringCoder.
	scripter
		clickStep: [ :s | 
			s
				label: 'Click CSS string';
				// GtCSSExpandableSourceCoderElement;
				// BlAttributedTextElement;
				@ [ :each | each text asString = 'background111' ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> expandInlineCSSCoder [
	<gtExample>
	| scripter |
	scripter := self expandNormalMethod.
	scripter
		clickStep: [ :s | 
			s
				label: 'Click Method Expander';
				// BrInlineExpanderElement ];
		assertStep: [ :s | 
			s
				label: 'Check for CSS Coder in expansion';
				// GtExpandableSourceCoderElement;
				// GtCSSExpandableSourceCoderElement;
				exists ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> expandNormalMethod [
	<gtExample>
	| scripter |
	scripter := self cssMethodCoder.
	scripter
		clickStep: [ :s | 
			s
				label: 'Click Normal Method';
				// GtExpandableSourceCoderElement;
				// BlAttributedTextElement;
				@ [ :each | each text asString = 'nonCSSmethod' ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> generateClassWithCSS [
	<gtExample>
	<after: #cleanUp>
	| cls |
	environment := GtPharoDummiesGenerator new
			amountOfPackages: 1;
			amountOfClasses: 1;
			amountOfMethods: 0;
			generate.
	cls := self cssClass.
	0
		to: 15
		do: [ :i | cls compile: (self sourceForIndex: i) classified: #'css string' ].
	cls compile: 
'nonCSSmethod
	self background000' classified: #'normal method'
]

{ #category : #'examples - scripter' }
GtCSSStringCoderExamples >> highlighter [
	<gtExample>
	| scripter |
	scripter := self expandCSSItem.
	scripter
		doStep: [ :s | 
			s
				// GtSourceCoderEditorId;
				block: [ :each | 
					each selecter
						from: 25 to: 26;
						select ] ].
	scripter
		secondaryClickStep: [ :s | 
			s
				label: 'Open menu';
				// GtSourceCoderEditorId ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Open references';
				onSpaceRoot;
				// #'context-menu--css-property-reference' ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Expand coder';
				id: GtPagerPageElementId index: 2;
				on: GtCSSSourceCoderCollapsedContentElement index: 1 ].
	scripter
		doStep: [ :s | 
			s
				id: GtPagerPageElementId index: 2;
				// GtSourceCoderEditorId;
				block: [ :each | 
					| found |
					found := false.
					each text attributesFinder
						findAttribute: GtSourceReferenceHighlighter highlightAttribute
						indicesDo: [ :first :last | 
							found := true.
							self
								assert: (each text from: first to: last) asString
								equals: 'background' ].
					self assert: found ] ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> methodUpdatedFromOutsideCoder [
	<gtExample>
	| scripter newSource methodSource |
	scripter := self updatingMethod.
	self cssClass compile: (self sourceForIndex: 1) classified: #'css string'.
	self waitForCompile: scripter.
	newSource := self sourceForIndex: 1.
	newSource replaceAll: Character lf with: Character cr.
	methodSource := environment anyDummyRootClass realClass
			sourceCodeAt: #background111.
	methodSource replaceAll: Character lf with: Character cr.
	self assert: methodSource equals: newSource.
	scripter
		assertStep: [ :s | 
			s
				// GtSourceCoderEditorId;
				value: [ :each | each text asString ] equals: (self cssSourceForIndex: 1) ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> removeMethod [
	<gtExample>
	| scripter |
	scripter := self expandCSSItem.
	scripter
		clickStep: [ :s | 
			s
				label: 'Click remove method button';
				// GtCSSExpandableSourceCoderElement;
				@ [ :each | each isExpanded ];
				// GtMethodCoderRemoveActionId ];
		clickStep: [ :s | 
			s
				label: 'Click final remove button';
				onSpaceRoot;
				onDropdown: true;
				// #'change-button-action' ].
	self
		assert: (environment anyDummyClass realClass selectors includes: #background111) not.

	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> sourceForIndex: i [
	^ 'background<1s>
	%<cssString>
	^ ''.background<1s> {
	background: #<1s>;
}'''
		expandMacrosWith: (((i printStringRadix: 16) last: 1) repeat: 3)
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> updatingMethod [
	<gtExample>
	| scripter additionalSource newSource index methodSource |
	scripter := self expandCSSItem.
	scripter
		assertStep: [ :s | 
			s
				// GtSourceCoderEditorId;
				value: [ :each | each text asString ] equals: (self cssSourceForIndex: 1) ].
	additionalSource := '.test { color: #aaa; } '.
	(scripter type: additionalSource) play.
	scripter
		clickStep: [ :s | 
			s
				label: 'Save';
				// GtMethodCoderSaveActionId ].
	newSource := self sourceForIndex: 1.
	index := newSource indexOf: $'.
	newSource := (newSource first: index) , additionalSource
			, (newSource allButFirst: index).
	newSource replaceAll: Character lf with: Character cr.
	methodSource := self cssClass sourceCodeAt: #background111.
	methodSource replaceAll: Character lf with: Character cr.
	self assert: methodSource equals: newSource.
	^ scripter
]

{ #category : #'as yet unclassified' }
GtCSSStringCoderExamples >> waitForCompile: scripter [
	(Delay forMilliseconds: 50) wait.
	scripter pulse
]
