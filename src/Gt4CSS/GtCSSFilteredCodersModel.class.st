Class {
	#name : #GtCSSFilteredCodersModel,
	#superclass : #GtFilteredCodersModel,
	#category : 'Gt4CSS-Model'
}

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersModel >> gtViewFor: aView [
	<gtView>
	^ aView forward
		title: 'CSS strings';
		object: [ GtCSSFilteredCodersViewModel new streamingCodersModel: self ];
		view: #gtViewFor:context:
]

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersModel >> initialize [
	super initialize.
	SystemAnnouncer uniqueInstance weak
		when: MethodAdded
			send: #onMethodAdded:
			to: self;
		when: MethodRemoved
			send: #onMethodRemoved:
			to: self
]

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersModel >> newCoderFor: aMethod [
	^ GtCSSCoderModel new forMethod: aMethod
]

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersModel >> onMethodAdded: aMethodAddedAnnouncement [
	(filter matches: aMethodAddedAnnouncement methodAdded) ifFalse: [ ^ self ].
	self privateAddCoderFor: aMethodAddedAnnouncement methodAdded
]

{ #category : #'as yet unclassified' }
GtCSSFilteredCodersModel >> onMethodRemoved: aMethodRemovedAnnouncement [
	(filter matches: aMethodRemovedAnnouncement methodRemoved) ifFalse: [ ^ self ].

	self privateRemoveCoderFor: aMethodRemovedAnnouncement methodRemoved
]
