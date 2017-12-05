<!DOCTYPE html>
<html lang="en" xmlns:g="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Grails"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="lib/iconfont/material-icons.css"/>
    <asset:stylesheet src="lib/bootstrap/bootstrap.min.css"/>
    <asset:javascript src="lib/jquery-3.2.1.min.js"/>
    <asset:javascript src="application.js"/>
    <asset:javascript src="lib/bootstrap/bootstrap.min.js"/>
    <asset:javascript src="lib/popper.js"/>
    <asset:stylesheet src="datatables/datatables.css"/>
    <asset:javascript src="datatables/datatables.js"/>

    <g:layoutHead/>
    <style>
    /* Set height of the grid so .sidenav can be 100% (adjust as needed) */
    .row.content {height: 550px}

    /* Set gray background color and 100% height */
    .sidenav {
      background-color: #f1f1f1;
      height: 100%;
    }
    }
  </style>
</head>
<body>


<nav class="navbar  navbar-dark bg-dark text-white sticky-top">
    <div class="container-fluid">

        <div class="row col-md-12">

            <g:link controller="home" action="index" class="navbar-brand py-2 col-md-10">
                <h5><i class="material-icons">home</i> SX-RX</h5>
            </g:link>

            <div class="dropdown ">
                <sec:ifLoggedIn>
                    <a class="nav-link dropdown-toggle text-white  " data-toggle="dropdown" href="#" id="navbarDropdown" role="button"  aria-haspopup="true" aria-expanded="false" >
                        <i class="material-icons">account_circle</i>
                        <sec:loggedInUserInfo field="username"/>
                    </a>
                    <ul class="dropdown-menu" role="menu">
                        <li>
                            <g:form controller="logout" class="navbar-form navbar-left" role="search">

                                <button type="submit" class="btn btn-default"> <i class="fa fa-power-off"></i> Cerrar sesión</button>
                            </g:form>

                        </li>
                        <sec:ifAllGranted roles="ROLE_ADMIN">
                            <li>
                                <g:link controller="usuario" ><i class="fa fa-users"></i> Usuarios</g:link>
                            </li>
                            <li>
                                <g:link controller="consulta" action="sesiones"><i class="fa fa-cogs"></i> Sessiones</g:link>
                            </li>
                            <li>
                                <g:link controller="configuracion" action="index"><i class="fa fa-building-o"></i> Configuración</g:link>
                            </li>
                            <li>
                                <g:link controller="importador" action="index"><i class="fa fa-upload"></i> Importacion</g:link>
                            </li>
                        </sec:ifAllGranted>
                    </ul>

                </sec:ifLoggedIn>
            </div>

        </div>

    </div>
</nav>


<div class="container-fluid">
    <div class="row">

      <nav class="col-sm-3 col-md-2 hidden-xs-down bg-faded sidebar">
            <ul class="nav nav-pills flex-column">
                <li class="nav-item">
                    <g:link controller="surtidoAnalisis" action="dashboard" class="nav-link active mb-2 mt-2" >Dashboard <span class="sr-only">(current)</span></g:link>
                </li>
                <li class="nav-item">
                    <g:link controller="surtidoAnalisis" action="administracion" class="nav-link mb-2 bg-light text-dark" >Administracion</g:link>
                </li>
                <li class="nav-item">
                    <g:link controller="surtidoAnalisis" action="filtrar" class="nav-link mb-2 bg-light text-dark" >Rastreo</g:link>
                </li>
                <li class="nav-item">
                    <a class="nav-link mb-2 bg-light text-dark" href="#">Export</a>
                </li>
            </ul>

            <ul class="nav nav-pills flex-column">
                <li class="nav-item">
                    <a class="nav-link mb-2 bg-light text-dark" href="#">Nav item</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link mb-2 bg-light text-dark" href="#">Nav item again</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link mb-2 bg-light text-dark" href="#">One more nav</a>
                </li>

            </ul>

            <ul class="nav nav-pills flex-column">
                <li class="nav-item">
                    <a class="nav-link mb-2 bg-light text-dark" href="#">Nav item again</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link mb-2 bg-light text-dark" href="#">One more nav</a>
                </li>

            </ul>
        </nav>

        <div class="col-md-10">

            <g:layoutBody/>

        </div>


    </div><!-- end .container-->


    <footer class="bg-dark text-white mt-4 fixed-bottom">
        <div class="container-fluid py-3">
            <div class="row">
                <ul class="nav  nav-fill">
                    <li class="nav-item">
                        ©2017 Papel s.a.
                    </li>
                    <li class="nav-item">

                    </li>
                    <li class="nav-item">

                    </li>
                    <li class="nav-item">

                    </li>
                    <li class="nav-item">

                    </li>
                    <li class="nav-item">

                    </li>
                </ul>
            </div>

        </div>
    </footer>




</body>
</html>
