Class {
	#name : #AsyncCSSStringMethodsStream,
	#superclass : #AsyncImageMethodsStream,
	#category : #'Gt4CSS-Filter'
}

{ #category : #initialization }
AsyncCSSStringMethodsStream >> initialize [
	super initialize.

	stream := (Pragma allNamed: 'cssString') asAsyncStream
			collect: [ :each | each method ]
]
