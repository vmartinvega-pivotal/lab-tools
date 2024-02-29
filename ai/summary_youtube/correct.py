## Installing Library
!pip install lmproof

## Importing Library
import lmproof as lm

## Function for proofreading 
def Proofread(text):
    proof = lm.load("en")
    error_free_text = proof.proofread(text)
    return error_free_text

## Sample Text
TEXT = 'The varialbe was initilized with an invald value, causing the progam to throw a runtime erro.'

## Function Call 
Print(Proofread(TEXT))