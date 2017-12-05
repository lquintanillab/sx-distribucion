
import grails.plugin.springsecurity.SpringSecurityUtils


def loggedIn = { ->
    //springSecurityService.principal instanceof String
    springSecurityService.isLoggedIn()
}
def loggedOut = { ->
    !springSecurityService.isLoggedIn()
}
def isAdmin = { ->
    SpringSecurityUtils.ifAllGranted('ADMIN')
}



navigation={


}