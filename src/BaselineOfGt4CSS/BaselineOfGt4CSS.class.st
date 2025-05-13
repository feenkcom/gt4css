Class {
	#name : #BaselineOfGt4CSS,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4CSS
}

{ #category : #baseline }
BaselineOfGt4CSS >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'GToolkit4LSP'
					with: [ spec repository: 'github://feenkcom/gt4lsp:main/src' ];
				baseline: 'GToolkitCoder'
					with: [ spec repository: 'github://feenkcom/gtoolkit-coder:main/src' ];
				package: 'Gt4CSS' ]
]
