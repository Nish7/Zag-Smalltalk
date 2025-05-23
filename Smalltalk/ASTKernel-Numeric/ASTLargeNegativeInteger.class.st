Class {
	#name : 'ASTLargeNegativeInteger',
	#superclass : 'ASTLargePositiveInteger',
	#type : 'bytes',
	#category : 'ASTKernel-Numeric',
	#package : 'ASTKernel-Numeric'
}

{ #category : 'arithmetic' }
ASTLargeNegativeInteger >> abs [
	^ self negated
]

{ #category : 'arithmetic' }
ASTLargeNegativeInteger >> negated [
	^ self copyto: (ASTLargePositiveInteger new: self bytesCount)
]

{ #category : 'testing' }
ASTLargeNegativeInteger >> negative [
	"Answer whether the receiver is mathematically negative."

	^ true
]

{ #category : 'truncation and round off' }
ASTLargeNegativeInteger >> normalize [
	"Check for leading zeroes and return shortened copy if so"

	| sLen val len oldLen minVal |
	"First establish len = significant length"
	len := oldLen := self bytesCount.
	[ len = 0
		ifTrue: [ ^ 0 ].
	(self byteAt: len) = 0 ] whileTrue: [ len := len - 1 ].	"Now check if in SmallInteger range"
	sLen := 4.	"SmallInteger minVal digitLength"
	len <= sLen
		ifTrue: [ minVal := ASTSmallInteger minVal.
			(len < sLen or: [ (self byteAt: sLen) < minVal lastDigit ])
				ifTrue: [ val := 0.
					len to: 1 by: -1 do: [ :i | val := val * 256 - (self byteAt: i) ].
					^ val ].
			"If high digit less, then can be small"
			1 to: sLen do: [ :i"If all digits same, then = minVal"
				 | 
				(self byteAt: i) = (minVal byteAt: i)
					ifFalse: [ len < oldLen
							ifTrue: [ ^ self growto: len ]
							ifFalse: [ ^ self ] ]
				"Not so; return self shortened" ].
			^ minVal ].	"Return self, or a shortened copy"
	len < oldLen
		ifTrue: [ ^ self growto: len ]
		ifFalse: [ ^ self ]
]

{ #category : 'printing' }
ASTLargeNegativeInteger >> printOn: aStream base: b [
	"Refer to the comment in Integer|printOn:base:."

	aStream nextPut: $-.
	super printOn: aStream base: b
]

{ #category : 'converting' }
ASTLargeNegativeInteger >> sign [
	"Optimization. Answer -1 since receiver is less than 0."

	^ -1
]
