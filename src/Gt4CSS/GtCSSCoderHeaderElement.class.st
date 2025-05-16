Class {
	#name : #GtCSSCoderHeaderElement,
	#superclass : #BrVerticalPane,
	#traits : 'TGtWithTextualCoderViewModel',
	#classTraits : 'TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'selector'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #accessing }
GtCSSCoderHeaderElement >> behavior [
	textualCoderViewModel ifNil: [ ^ self class ].
	^ textualCoderViewModel coderModel behavior
]

{ #category : #initialization }
GtCSSCoderHeaderElement >> initialize [
	super initialize.
	self vFitContent.
	self hMatchParent.
	selector := BrLabel new
			vFitContent;
			hMatchParent;
			aptitude: BrGlamorousLabelAptitude new glamorousCodeFont bold.
	self addChild: selector as: #cssSelector
]

{ #category : #'api - textual coder view model' }
GtCSSCoderHeaderElement >> onTextualCoderViewModelChanged [
	selector
		text: (textualCoderViewModel
				ifNil: [ '' ]
				ifNotNil: [ textualCoderViewModel coder selector ]) asRopedText
]

{ #category : #accessing }
GtCSSCoderHeaderElement >> package [
	textualCoderViewModel ifNil: [ ^ self class package ].
	^ textualCoderViewModel coderModel package
]

{ #category : #accessing }
GtCSSCoderHeaderElement >> showPackageAndClass: aBoolean [
	self childNamed: #breadcrumbs ifFound: [ :each | self removeChild: each ].
	aBoolean
		ifTrue: [ | breadcrumbs |
			breadcrumbs := BrHorizontalPane new fitContent.
			breadcrumbs
				addChild: (BrButton new
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
						action: [ self spawnPackage ]).
			breadcrumbs
				addChild: (BrLabel new
						aptitude: (BrGlamorousLabelAptitude new thin
								padding: (BlInsets left: 5 right: 5);
								foreground: self theme button defaultTextColor);
						text: '>').
			breadcrumbs
				addChild: (BrButton new
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
						action: [ self spawnBehavior ]).
			self
				addChild: breadcrumbs
				at: 1
				as: #breadcrumbs ]
]

{ #category : #'as yet unclassified' }
GtCSSCoderHeaderElement >> spawnBehavior [
	self phlow spawnTool: (GtClassCoderTool forClass: self behavior)
]

{ #category : #menu }
GtCSSCoderHeaderElement >> spawnPackage [
	self phlow spawnTool: (GtPackageCoderTool package: self package)
]
