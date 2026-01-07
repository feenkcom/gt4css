Class {
	#name : #GtCSSStringClassFilter,
	#superclass : #GtSearchMethodsContainedInClassFilter,
	#category : #'Gt4CSS-Filter'
}

{ #category : #accessing }
GtCSSStringClassFilter >> defaultFilterScope [
	^ AsyncCSSStringBehaviorMethodsString forBehavior: filterClass
]

{ #category : #'as yet unclassified' }
GtCSSStringClassFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod methodClass instanceSide = filterClass instanceSide
		and: [ aCompiledMethod pragmas anySatisfy: [ :each | each selector = #cssString ] ]
]

{ #category : #'as yet unclassified' }
GtCSSStringClassFilter >> resultType [
	^ GtAsyncCSSStringTypedGroupStream
]
