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
				spec repository: 'github://feenkcom/gt4lsp:v0.7.234/src' ].
		spec
			baseline: 'GToolkit4Pharo' with: [
				spec repository: 'github://feenkcom/gt4pharo:v0.7.331/src' ].
		spec
			baseline: 'CSSParser' with: [
				spec repository: 'github://j-brant/SmaCC:002450820e55dac98fb3164e856ecc69a2edd101/src' ].

		spec package: 'Gt4CSS' with: [
			spec requires: #(#GToolkit4LSP #GToolkit4Pharo #CSSParser) ].
		spec package: 'Gt4CSS-Examples-RustEditor' with: [
			spec requires: #(#Gt4CSS) ].
	]
]
