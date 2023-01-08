
import ee

def wrapper_eeAuthenticate():

    thisFunctionName = "wrapper_eeAuthenticate"
    print( "\n\n\n### " + thisFunctionName + "() starts ..." )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\n# calling ee.Authenticate() ..." )
    ee.Authenticate(auth_mode = "appdefault")

    print( "\n# calling ee.Initialize() ..." )
    ee.Initialize()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\n### " + thisFunctionName + "() exits ..." )
    return( None )

##### ##### ##### ##### #####
