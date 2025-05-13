Class {
	#name : #GtCSSCoderHeaderElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtWithTextualCoderViewModel',
	#classTraits : 'TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'selector'
	],
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSCoderHeaderElement >> initialize [
	super initialize.
	self fitContent.
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
