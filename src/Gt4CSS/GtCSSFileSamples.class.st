Class {
	#name : #GtCSSFileSamples,
	#superclass : #Object,
	#category : #'Gt4CSS-Examples'
}

{ #category : #examples }
GtCSSFileSamples >> cssDefinitionFromMethod [
	<gtExample>
	| scripter source method index |
	method := self class >> #writeOn:.
	source := method sourceCode.
	scripter := BlScripter new.
	scripter
		substep: 'Show a coder'
		do: [ :aStep | 
			aStep set
				label: 'Initialize Coder Model';
				model: [ GtPharoMethodCoder new forMethod: method ];
				play.
			aStep set
				label: 'Initialize Coder UI';
				element: [ :aCoder | aCoder asElement ];
				onModel;
				play ].
	index := (source indexOfSubCollection: 'style: ''') + 8.
	scripter
		doStep: [ :s | 
			s
				label: 'Select part of the method';
				// GtSourceCoderEditorId;
				action: [ :aSourceEditor | 
					aSourceEditor selecter
						from: index to: index + 1;
						select ] ].
	scripter
		secondaryClickStep: [ :s | 
			s
				label: 'Open context menu';
				id: GtSourceCoderEditorId ].
	scripter
		substeps: 'Click on css menu item'
		do: [ :aStep | 
			aStep
				clickStep: [ :s | 
					s
						onSpaceRoot;
						id: #'context-menu--css-style' ].
			aStep
				assertStep: [ :s | 
					s
						label: 'Assert Spawn Object Event';
						satisfies: [ :theScripter | 
							theScripter events reversed
								detectEventOfClass: GtPhlowObjectToSpawn
								ifFound: [ :event | true ]
								ifNone: [ false ] ];
						onScripter ] ].
	scripter
		secondaryClickStep: [ :s | 
			s
				label: 'Open context menu';
				id: GtSourceCoderEditorId ].
	^ scripter
]

{ #category : #examples }
GtCSSFileSamples >> gtCSSClassMethodReferences [
	<gtExample>
	| refs |
	refs := 'le-nav-link' gtCSSClassMethodReferences.
	self assert: (refs contents includes: self class >> #writeOn:).
	^ refs
]

{ #category : #examples }
GtCSSFileSamples >> gtCSSStringPropertyReferences [
	<gtExample>
	| refs |
	refs := 'flex-direction' gtCSSStringPropertyReferences.
	self assert: (refs contents includes: self class >> #lepiter_common).
	^ refs
]

{ #category : #examples }
GtCSSFileSamples >> gtCSSStringSelectorReferences [
	<gtExample>
	| refs |
	refs := 'le-nav-link' gtCSSStringSelectorReferences.
	self assert: (refs contents includes: self class >> #lepiter_common).
	^ refs
]

{ #category : #'css strings' }
GtCSSFileSamples >> lepiter_common [
	<cssString>
	^ '/*
    Common styling
 */


/* Font definition */

@font-face {
 font-family:"sources-regular";
 src:url("/assets/v1/src/fonts/sourcesanspro-bold-webfont.woff");
 font-weight: bold;
}
@font-face {
 font-family:"sources-regular";
 src:url("/assets/v1/src/fonts/sourcesanspro-regular-webfont.woff");
  font-weight: regular;
}

:root {
    /* colors */
    --active-color: #eee;
    --hovered-color: #ddd;
    --text-color: black;
    --link-text-color: var(--text-color);

    /* space */
    --link-indent: 1rem;

    /* --min-column-width does not work in media queries.
     It is here for documentation purposes only. */
    --min-column-width: 992px;
}

body {
    /*
        The body contains a main content and a footer.
        We want the footer to be below the content and stick in
        the bottom of viewport if the content height is smaller than
        a viewport height (excluding the footer height).
    */
    display: flex;
    flex-direction: column;

    /* fallback height */
    min-height: 100vh;

    /* new small viewport height for modern browsers */
    min-height: 100svh;

   font-family:"sources-regular", sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
}

/* If the main content height is smaller than the viewport height,
the margin will occupy the spare area. */
body footer {
    margin-top: auto;
}

/* Link styling */
h1 a, 
h2 a, 
h3 a, 
h4 a, 
h5 a, 
h6 a {
    text-decoration: unset;
}

a {
    text-decoration: underline;
    color: var(--link-text-color);
}

a:hover {
    text-decoration: none;
    color: var(--link-text-color);
    background-color: var(--hovered-color);
}

a.active {
    background-color: var(--active-color)
}

/* Content row with navigation and main content column. */
/* Without this, we have an issue with viewport width overlap.
 As a consequence, there is a horizontal scrollbar. */
.le-row {
    margin-inline: 0;
}
/* Keep the navigatin index at the viewport start.
It means that the navigation item highlight will start at the
 beginning of the viewport. */
.le-nav-column {
    padding-inline-start: 0;
}

/*
    Navigation index
*/

/* Header */
.le-logo {
    margin-block: 0.5rem;
}
.le-logo-g {
    font-weight: lighter;
}
.le-logo-t {
    font-weight: bold;
}
.le-logo-book {
    font-weight: bold;
}
.le-logo-version {
    font-weight: lighter;
}

/* Scrollable navigation list */
.le-nav-scrollable {
    /* Make the navigation list scrollable */
    /* fallback height */
    max-height: 100vh;
    /* new small viewport height for modern browsers */
    max-height: 100svh;
    top: 0;
    bottom: 0;
    overflow-y: auto;

    /* smaller font */
    font-size: 0.88rem;
    color: var(--text-color);
}

/* Expanded navigation list */
@media (min-width: 992px) {
    .le-nav-scrollable {
        /* border that splits navigation list from the main content */
        border-inline-end: solid var(--active-color) thin;

        /* same space between navigation list and footer
         as between main content and the footer */
        padding-block-end: 3rem;
    }
}

/* navigation links */
.le-nav-link {
    color: var(--link-text-color);
}

.le-nav-container a {
    text-decoration: none;
}

/* The root index items are separated */
.le-nav-item.le-nav-level-1 {
    padding-bottom: 1em;
}

/* The root index items are bold */
.le-nav-link.le-nav-level-1 {
    font-weight: bold;
}

/* Indent inner-navigation index links */
.le-nav-link.le-nav-level-2  {
    padding-left: calc(2 * var(--link-indent));
}

.le-nav-link.le-nav-level-3  {
    padding-left: calc(3 * var(--link-indent));
}

.le-nav-link.le-nav-level-4  {
    padding-left: calc(4 * var(--link-indent));
}

.le-nav-link.le-nav-level-5  {
    padding-left: calc(5 * var(--link-indent));
}

.le-nav-link.le-nav-level-6  {
    padding-left: calc(6 * var(--link-indent));
}

.le-nav-link.le-nav-level-7  {
    padding-left: calc(7 * var(--link-indent));
}

.le-nav-link.le-nav-level-8  {
    padding-left: calc(8 * var(--link-indent));
}

.le-nav-link.le-nav-level-9  {
    padding-left: calc(9 * var(--link-indent));
}

/*
	Meta data
*/

.le-post-meta {
	padding-bottom: 1rem;
}

.le-post-publish-date, 
.le-post-publish-user {
    color: #6c757d;
    font-size: 80%;
    margin-bottom: 0;
    margin-top: 0;
}

/*
    Footer
*/

.le-footer {
    background-color: black;
    color: white;
}

.le-footer a {
    text-decoration: underline;
    color: inherit;
}

/*
    Content
*/

.le-main-title {
    font-weight: bold;
}

.le-main-container h1,
.le-main-container h2,
.le-main-container h3,
.le-main-container h4,
.le-main-container h5,
.le-main-container h6,
.le-main-container .h1,
.le-main-container .h2,
.le-main-container .h3,
.le-main-container .h4,
.le-main-container .h5,
.le-main-container .h6  {
    font-weight: bold;
    margin-block-end: 4px;
}

.le-main-container h1 {
  margin-block-start: 3em;
}

h1.le-main-title {
  margin-block-start: 0;
}

.le-main-container h2 {
  margin-block-start: 2em;
}

.le-main-container h3 {
  margin-block-start: 1em;
}

.le-main-container h4,
.le-main-container h5,
.le-main-container h6 {
  margin-block-start: 0.5em;
}
'
]

{ #category : #'css strings' }
GtCSSFileSamples >> lepiter_snippet [
	<cssString>
	^ '/*
    Common rules
 */

:root {
    /* --min-column-width does not work in media queries.
     It is here for documentation purposes only. */
    --min-column-width: 992px;
}

/* Add space at the top and bottom of figures */
main figure {
    padding-block: 1rem;
}

/* Add shadow around figures */
main figure > img {
    max-width: 100%;
    background-color: white;
}

main figure >img:hover {
    box-shadow: 0 0 5px 5px lightgray;
}

figcaption {
    font-size: 14px;
    color: #6c757d;
    text-align: center;
}

/*
    Snippet children.
    Disable the indent. We need to implement collapsable widget first.
 */

/* Indent snippet children. Do not indent the top-snippet children. */
/*.snippet-children .snippet-children {
    padding-inline-start: 0.5rem;
}*/

/* Make the snippet children indent more apparent on large screens. */
/*@media (min-width: 992px) {
    .snippet-children .snippet-children {
        padding-inline-start: 1rem;
    }
}*/

/* Widths */

.fullWidth {
  width: 100%;
}

/* Limit snippet content width on large screens.
   It does not limit headings. */
@media (min-width: 992px) {
  .paragraphWidth {
    width: 608px;
  }
  .documentWidth {
    width: 808px;
  }
}



/*
    --------------------------------
    Snippets other than text snippet
    --------------------------------
 */


/*
    --------------------------------
    Text snippet
    --------------------------------
 */

/*
    --------------------------------
    Text snippet - annotations
    --------------------------------
 */

.annotation {
}

.annotation-label {
}

.annotation-label-code {
    font-family: "Source Code Pro", monospace;
    background-color: #F0F0F0;
}

.annotation-label-code:hover {
    background-color: #E0E0E0;
}

/* indicates that this is a clickable annotation label
   which should expand/collapse .expandable-annotation-view siblings */
.expandable-annotation-label {
}

/* indicates that the annotation view is expanded */
.annotation-sibling-is-expanded {
}

/* indicates that the annotation view is collapsed */
.annotation-sibling-is-collapsed {
}

/* indicates that this is an expandable annotation view */
.expandable-annotation-view {
}

/* indicates that this is an annotation view is expanded */
.expanded-annotation-view {
    display: block;
}

/* indicates that this is an annotation view is collapsed */
.collapsed-annotation-view {
    display: none;
}

.code-snippet code {
    font-family: "Source Code Pro", monospace;
    color: inherit;
    white-space: pre;
    display: block;
    margin-block-end: 1rem;
}

/*
    --------------------------------
    Other rules
    --------------------------------
 */

.hidden_annotation_v3 {
    display: none;
}

.visible_annotation_v3 {
    display: block;
}

.expandable_annotation_label {
}

.collapsed_annotation_body::after {

}

.expanded_annotation_body::after {

}

.expandable_annotation_body {

}

.pharo-method-snippet {

}

.pharo-method-snippet::after {
    content: "Pharo method";
    color: #aaa;
    font-size: 0.8rem;
}

.pharo-class-definition {

}

.pharo-class-definition::after {
    content: "Pharo class definition";
    color: #aaa;
    font-size: 0.8rem;
}

.class_annotation {
    font-family: "Source Code Pro", monospace;
    background-color: #F0F0F0;
}

.hidden_annotation .class_definition {
    display: none;
}

.visible_annotation .class_definition {
    display: block;
}

.class_definition {
    white-space: pre;
    background-color: #F8F8F8;
}

.example_annotation {
}

.example_definition {
    font-family: "Source Code Pro", monospace;
    white-space: pre;
    margin-top: 10pt;
    margin-left: 20pt;
    background-color: #F8F8F8;
}

.example_result {
    font-family: "Source Code Pro", monospace;
    white-space: pre;
    margin-top: 10pt;
    margin-left: 20pt;
    background-color: #F8F8F8;
}

.code_block {
    font-family: "Source Code Pro", monospace;
}

.snippet {
    margin-top: 10pt;
}
.textual-snippet {

}

.code-snippet {
    font-family: "Source Code Pro", monospace;
    border-left: 10px solid #eee;
    padding-left: 10px;
    border-radius: 5px;
    tab-size: 4;
}

.pharo-snippet {

}

.pharo-snippet::after {
    content: "Pharo";
    color: #aaa;
    font-size: 0.8rem;
}

.pharolink-snippet::after {
    content: "PharoLink";
    color: #aaa;
    font-size: 0.8rem;
}

.python-snippet::after {
    content: "Python";
    color: #aaa;
    font-size: 0.8rem;
}

.javascript-snippet::after {
    content: "JavaScript";
    color: #aaa;
    font-size: 0.8rem;
}

.gemstone-snippet::after {
    content: "GemStone";
    color: #aaa;
    font-size: 0.8rem;
}

.changes-snippet::after {
    content: "Pharo changes";
    color: #aaa;
    font-size: 0.8rem;
}

.graphql-snippet::after {
    content: "GraphQL";
    color: #aaa;
    font-size: 0.8rem;
}

.graphqlinput-snippet::after {
    content: "GraphQL input";
    color: #aaa;
    font-size: 0.8rem;
}

.pharorewrite-snippet::after {
    content: "Pharo rewrite";
    color: #aaa;
    font-size: 0.8rem;
}

.pharoreplace-snippet::after {
    content: "Pharo replace";
    color: #aaa;
    font-size: 0.8rem;
}

.robocodermetamodel-snippet::after {
    content: "Robocoder metamodel";
    color: #aaa;
    font-size: 0.8rem;
}

.text-snippet {

}

.picture-snippet {
    margin-bottom: 2rem;
}

/* Word snippet */

.explanation-word {
    font-weight: bold;
    margin-block-end: 0;
}

.explanation-meaning {
    font-style: italic;
    margin-block-end: 0;
}

.explanation-definition {
    font-style: italic;
    margin-block-end: 0;
    margin-inline-start: 1rem;
}

.explanation-example {
    color: #aaa;
    margin-inline-start: 1rem;
}

.tweet-reference-snippet {

}

.youtube-reference-snippet {
    position: relative;
    padding-bottom: 56.25%;
    /* 16:9 */
    padding-top: 25px;
    height: 0;
}

.youtube-reference-snippet iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}

.height-one-em {
    height: 1rem;
}

.no_bottom_margin {
    margin-bottom: 0;
}


/*
    LEGACY CODE for a backward compatibility reasons
 */

.method_annotation {
    font-family: "Source Code Pro", monospace;
    background-color: #F0F0F0;
}

.hidden_annotation .method_definition {
    display: none;
}

.visible_annotation .method_definition {
    display: block;
}

.method_definition {
    font-family: "Source Code Pro", monospace;
    white-space: pre;
    background-color: #F8F8F8;
}

.hidden_annotation>.method_definition {
    display: none;
}

.visible_annotation>.method_definition {
    display: block;
}

/*
    End of LEGACY CODE
 */
'
]

{ #category : #'sample methods' }
GtCSSFileSamples >> writeOn: aStream [
	aStream
		link: 'Glamorous Toolkit'
		to: 'https://gtoolkit.com'
		style: 'le-nav-link'.
	aStream label: 'Some label' style: 'annotation-label'
]
