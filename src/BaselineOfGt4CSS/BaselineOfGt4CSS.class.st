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
				spec repository: 'github://feenkcom/gt4lsp:v0.7.29/src' ].
		spec
			baseline: 'GToolkitCoder' with: [
				spec repository: 'github://feenkcom/gtoolkit-coder:v0.9.36/src' ].

		spec package: 'Gt4CSS'.
	]
]
