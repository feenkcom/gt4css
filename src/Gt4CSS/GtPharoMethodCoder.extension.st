Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4CSS' }
GtPharoMethodCoder >> addCSSStringAddOns: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 300>
	(self extractableNodesFrom: aCoderViewModel)
		ifNotEmpty: [ :nodes | 
			| node index |
			node := nodes first.
			node isLiteral ifFalse: [ ^ self ].
			node literalValue isString ifFalse: [ ^ self ].
			node parent isMessage ifFalse: [ ^ self ].
			index := node parent arguments identityIndexOf: node.
			index = 0 ifTrue: [ ^ self ].
			(node parent selectorParts at: index) source = 'style:' ifFalse: [ ^ self ].
			(coderAddOns
				addContextMenuItem: (self
						createLabel: 'Rename CSS class'
						description: node literalValue)
				group: (BrMenuItemGroupConfiguration new
						name: 'CSS';
						priority: 100)
				hover: (self highlightNodesBlock: nodes)
				leave: self removeHighlightBlock
				action: [ :cvm :element | 
					(GtCSSStringRenameSelectorController new
						sourceCoderViewModel: cvm;
						originalNode: node) execute ]
				id: #'context-menu--css-rename-selector')
					ifNotNil: [ :anAction | anAction priority: 300.1 ].
			(coderAddOns
				addContextMenuItem: (self
						createLabel: 'Browse CSS definitions'
						description: node literalValue)
				group: (BrMenuItemGroupConfiguration new
						name: 'CSS';
						priority: 100)
				hover: (self highlightNodesBlock: nodes)
				leave: self removeHighlightBlock
				action: [ :cvm :element | element phlow spawnObject: node literalValue gtCSSStringSelectorReferences ]
				id: #'context-menu--css-style')
					ifNotNil: [ :anAction | anAction priority: 300.2 ] ]
]
