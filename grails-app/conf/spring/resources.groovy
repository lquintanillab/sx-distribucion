import sx.security.UserPasswordEncoderListener


import sx.distribucion.CustomAuditLogListener

// Place your Spring DSL code here
beans = {
    userPasswordEncoderListener(UserPasswordEncoderListener)


    customAuditLogListener(CustomAuditLogListener) {
        dataSource = ref('dataSource')
    }



}
