Extension { #name : #GtSearchBinaryFilter }

{ #category : #'*Gt4CSS' }
GtSearchBinaryFilter >> cssShowBehavior [
	^ self children anySatisfy: #cssShowBehavior
]
