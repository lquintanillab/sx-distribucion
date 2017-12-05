package sx.distribucion

import org.springframework.security.access.annotation.Secured

class HomeController {

    @Secured(['permitAll'])
    def index() { }




}
