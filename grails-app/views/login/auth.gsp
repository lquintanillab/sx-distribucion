<html>
<head>
    <meta name="layout" content="application"/>
    <title><g:message code='springSecurity.login.title'/></title>
</head>

<body>

<g:if test='${flash.message}'>
    <div class="login_message alert alert-danger col-md-12 text-center">${flash.message}</div>
</g:if>


<div class="container">
    <div class="jumbotron text-center ">
        <h1 class="display-3">Bienvenido!</h1>
        <div id="login">
            <div class="inner">

                <h4>
                    <div class="fheader"><g:message code='springSecurity.login.header'/></div>
                </h4>



                <form action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="cssform" autocomplete="off">
                    <p>
                        <label for="username"><g:message />Nombre:</label>
                        <input type="text" class="text_" name="${usernameParameter ?: 'username'}" id="username"/>
                    </p>

                    <p>
                        <label for="password"><g:message code='springSecurity.login.password.label'/>:</label>
                        <input type="password" class="text_" name="${passwordParameter ?: 'password'}" id="password"/>
                    </p>

                    <p id="remember_me_holder">
                        <input type="checkbox" class="chk" name="${rememberMeParameter ?: 'remember-me'}" id="remember_me" <g:if test='${hasCookie}'>checked="checked"</g:if>/>
                        <label for="remember_me"><g:message code='springSecurity.login.remember.me.label'/></label>
                    </p>

                    <button type="submit" id="submit" class="btn btn-info btn-lg>">Identificate</button>
                </form>
            </div>
        </div>

    </div>
</div>




<script>
    (function() {
        document.forms['loginForm'].elements['${usernameParameter ?: 'username'}'].focus();
    })();
</script>
</body>
</html>