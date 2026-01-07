Class {
	#name : #GtCSSSourceCoderEditorElement,
	#superclass : #GtSourceCoderEditorElement,
	#category : #'Gt4CSS-UI'
}

{ #category : #'as yet unclassified' }
GtCSSSourceCoderEditorElement >> createHeaderContextMenu [
	"wait for the addons to be computed"
	<return: #BrMenuItems>
	| aMenu aMenuItemsPromise |
	aMenu := BrMenuItems new.
	aMenu beGroupedElementType.
	aMenuItemsPromise := self textualCoderViewModel addOns asyncThen: 
					[:theAddOns |
					"extra context menu items that depend on ast and view model state such as selection"
					| theItems theContextMenuAstAddons theMenuItems |
					theContextMenuAstAddons := self textualCoderViewModel
								computeHeaderContextMenuAstAddOns.
					theItems := theAddOns contextMenuActions
								, theContextMenuAstAddons contextMenuActions.
					theItems := theItems reject: [:e | e title isNil].
					theMenuItems := theItems
								collect: [:eachAction | eachAction asBrMenuItemForCoderElement: self]
								thenReject: #isNil.
					self enqueueTask: (BlTaskAction new action: [aMenu items: theMenuItems])].
	self enqueueTask: (BlPromiseTask new promise: aMenuItemsPromise).
	^aMenu
]

{ #category : #initialization }
GtCSSSourceCoderEditorElement >> defaultTextEditorModel [
	^ GtLSPEditorModel withEditorMode: self defaultTextEditorMode
]
