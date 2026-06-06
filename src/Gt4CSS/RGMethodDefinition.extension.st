Extension { #name : #RGMethodDefinition }

{ #category : #'*Gt4CSS' }
RGMethodDefinition >> gtCSSStringFor: aView [
	<gtView>
	<gtToolView>
	
	(self method pragmas anySatisfy: [ :each | each selector = #cssString ])
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'CSS';
		priority: 2;
		object: [ self method  ];
		view: #gtCSSStringFor: 
]
