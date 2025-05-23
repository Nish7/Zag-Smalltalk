"
I represent a return
"
Class {
	#name : 'ASCBranch',
	#superclass : 'ASCNonStackReferencingOperations',
	#instVars : [
		'bb'
	],
	#category : 'Zag-Core-Operations',
	#package : 'Zag-Core',
	#tag : 'Operations'
}

{ #category : 'callgraph' }
ASCBranch >> dotEdgesOn: aStream from: aBasicBlock [

	aStream << '  '.
	aBasicBlock dotNameOn: aStream.
	aStream << ':end:e ->'.
	bb dotNameOn: aStream.
	^ aStream << ';
'
]

{ #category : 'callgraph' }
ASCBranch >> dotStringOn: aStream [

	aStream
		<< '<end>branch '
]

{ #category : 'Collection API' }
ASCBranch >> inlineWithFixedCFG: anASCodeGenerator [ 
]

{ #category : 'printing' }
ASCBranch >> inspectZagASTOn: aStream [

	super inspectZagASTOn: aStream.
	aStream
		<< ' -> ';
		<< bb label
]

{ #category : 'testing' }
ASCBranch >> needsContext: aStackContext [

	^ bb propagateContextFreeFor: aStackContext
]

{ #category : 'as yet unclassified' }
ASCBranch >> nextBasicBlocks [

	^ bb
]

{ #category : 'code generation' }
ASCBranch >> outputTo: output [

	^ output visitBranch: bb
]

{ #category : 'stack' }
ASCBranch >> resultStack: anASStack [

	stack := anASStack.
	^ anASStack
]

{ #category : 'as yet unclassified' }
ASCBranch >> with: target [

	bb := target

	
]
