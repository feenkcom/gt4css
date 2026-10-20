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
				baseline: 'GToolkit4Pharo'
					with: [ spec repository: 'github://feenkcom/gt4pharo:main/src' ];
				baseline: 'CSSParser' 
					with: [ spec repository: 'github://j-brant/SmaCC:/src' ];
				package: 'Gt4CSS'
					with: [ spec requires: #( GToolkit4LSP GToolkit4Pharo CSSParser ) ];
				package: 'Gt4CSS-Examples-RustEditor' 
					with: [ spec requires: #( Gt4CSS ) ] ]
]
