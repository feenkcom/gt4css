Class {
	#name : #BaselineOfGt4CSS,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4CSS
}

{ #category : #baseline }
BaselineOfGt4CSS >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkit4LSP' with: [
				spec repository: 'github://feenkcom/gt4lsp:v0.7.237/src' ].
		spec
			baseline: 'GToolkit4Pharo' with: [
				spec repository: 'github://feenkcom/gt4pharo:v0.7.337/src' ].
		spec
			baseline: 'CSSParser' with: [
				spec repository: 'github://j-brant/SmaCC:da3f53a5ccd8cf78f213da4661f681065a88fa68/src' ].

		spec package: 'Gt4CSS' with: [
			spec requires: #(#GToolkit4LSP #GToolkit4Pharo #CSSParser) ].
		spec package: 'Gt4CSS-Examples-RustEditor' with: [
			spec requires: #(#Gt4CSS) ].
	]
]
