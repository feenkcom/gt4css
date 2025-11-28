Class {
	#name : #AsyncCSSStringBehaviorMethodsString,
	#superclass : #AsyncBehaviorStream,
	#category : 'Gt4CSS-Filter'
}

{ #category : #initialization }
AsyncCSSStringBehaviorMethodsString >> initializeStream [
	stream := (((Pragma allNamed: #cssString in: self behavior), (Pragma allNamed: #cssString in: self behavior class)
			collect: [ :each | each method ])
			asSortedCollection: [ :a :b | a selector < b selector ]) asAsyncStream
			select: [ :each | each gtIsActive and: [ each methodClass isObsolete not ] ]
]
