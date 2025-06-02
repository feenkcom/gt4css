Class {
	#name : #GtCSSCoderHeaderElement,
	#superclass : #BrVerticalPane,
	#traits : 'TGtWithTextualCoderViewModel',
	#classTraits : 'TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'selector',
		'packageButton',
		'classButton'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #accessing }
GtCSSCoderHeaderElement >> behavior [
	textualCoderViewModel ifNil: [ ^ self class ].
	^ textualCoderViewModel coderModel behavior
]

{ #category : #accessing }
GtCSSCoderHeaderElement >> buildBreadcrumbs [
	| breadcrumbs |
	breadcrumbs := BrHorizontalPane new fitContent.
	packageButton := BrButton new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors defaultButtonTextColor;
					glamorousRegularSmallSize)
					+ (BrStyleCommonAptitude new
							default: [ :aStyle | 
								aStyle
									geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
									border: BlBorder empty ];
							hovered: [ :aStyle | aStyle border: self theme button hoveredBorderColor ]);
			label: self package name;
			action: [ self spawnPackage ].
	breadcrumbs addChild: packageButton.
	breadcrumbs
		addChild: (BrLabel new
				aptitude: (BrGlamorousLabelAptitude new thin
						padding: (BlInsets left: 5 right: 5);
						foreground: self theme button defaultTextColor);
				text: '>').
	classButton := BrButton new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors defaultButtonTextColor;
					glamorousRegularSmallSize)
					+ (BrStyleCommonAptitude new
							default: [ :aStyle | 
								aStyle
									geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
									border: BlBorder empty ];
							hovered: [ :aStyle | aStyle border: self theme button hoveredBorderColor ]);
			label: self behavior name;
			action: [ self spawnBehavior ].
	breadcrumbs addChild: classButton.
	self
		addChild: breadcrumbs
		at: 1
		as: #breadcrumbs
]

{ #category : #initialization }
GtCSSCoderHeaderElement >> buildLabel [
	selector := BrLabel new
			vFitContent;
			hMatchParent;
			aptitude: BrGlamorousLabelAptitude new glamorousCodeFont bold.
	self addChild: selector as: #cssSelector
]

{ #category : #initialization }
GtCSSCoderHeaderElement >> initialize [
	super initialize.
	self vFitContent.
	self hMatchParent.
	self buildBreadcrumbs.
	self buildLabel
]

{ #category : #'api - textual coder view model' }
GtCSSCoderHeaderElement >> onTextualCoderViewModelChanged [
	selector
		text: (textualCoderViewModel
				ifNil: [ '' ]
				ifNotNil: [ textualCoderViewModel coder selector ]) asRopedText.
	packageButton label: self package name.
	classButton label: self behavior name
]

{ #category : #accessing }
GtCSSCoderHeaderElement >> package [
	textualCoderViewModel ifNil: [ ^ self class package ].
	^ textualCoderViewModel coderModel package
]

{ #category : #accessing }
GtCSSCoderHeaderElement >> showPackageAndClass: aBoolean [
	self
		childNamed: #breadcrumbs
		ifFound: [ :each | 
			each
				visibility: (aBoolean ifTrue: [ BlVisibility visible ] ifFalse: [ BlVisibility gone ]) ]
]

{ #category : #'as yet unclassified' }
GtCSSCoderHeaderElement >> spawnBehavior [
	self phlow spawnTool: (GtClassCoderTool forClass: self behavior)
]

{ #category : #menu }
GtCSSCoderHeaderElement >> spawnPackage [
	self phlow spawnTool: (GtPackageCoderTool package: self package)
]
