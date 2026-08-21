"
Creation-code examples for CSS search filters.
"
Class {
	#name : #GtCSSSearchFiltersCreationStringExamples,
	#superclass : #GtSearchFiltersCreationStringExamples,
	#category : #'Gt4CSS-Examples'
}

{ #category : #'examples - parameterized' }
GtCSSSearchFiltersCreationStringExamples >> cssStringReferencesFilterCreationCode [
	<gtExample>
	^ self
		assertCreatioCodeFor: (GtCSSStringReferencesFilter new string: 'color')
		equals: 'GtCSSStringReferencesFilter new string: ''color''.'
]
