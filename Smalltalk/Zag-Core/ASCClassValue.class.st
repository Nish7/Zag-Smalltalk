"
I represent immutable values at compile time where all I know is the class.
"
Class {
	#name : 'ASCClassValue',
	#superclass : 'ASCVariable',
	#instVars : [
		'valueClass',
		'isRanged'
	],
	#category : 'Zag-Core-CodeGen',
	#package : 'Zag-Core',
	#tag : 'CodeGen'
}

{ #category : 'asserting' }
ASCClassValue >> assertIsValue [
]

{ #category : 'accessing' }
ASCClassValue >> inferType: anASCodeGenerator [ 

	^ valueClass
]

{ #category : 'common' }
ASCClassValue >> init: aClass [
		valueClass := aClass.
		^ self
]

{ #category : 'testing' }
ASCClassValue >> isMutable [

	^ false
]

{ #category : 'accessing' }
ASCClassValue >> isRanged [

	^ isRanged ifNil: [ isRanged := valueClass canUnderstand: #'<=']
]

{ #category : 'accessing' }
ASCClassValue >> kind [

	^ valueClass
]

{ #category : 'serializing' }
ASCClassValue >> makeManifest [
]

{ #category : 'accessing' }
ASCClassValue >> max [

	^ self isRanged
		  ifTrue: [ self min ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
ASCClassValue >> min [
^ nil
]
