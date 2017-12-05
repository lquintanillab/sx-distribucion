<!doctype html>
<html lang="en" class="no-js">
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
</head>
<body>

<nav class="bg-dark text-white   ">
    <div class="container ">

        <div class="row col-md-12">

            <g:link controller="home" action="index" class="navbar-brand py-2 col-md-2 sticky-top">
                <h5><i class="material-icons">home</i> SX-RX</h5>
            </g:link>

            <ul class="nav  nav-fill pt-3 col-md-3">
                <li>
                    <p >Surtido de pedidos: ${new Date().format('dd/MM/yyyy')}</p>
                </li>
            </ul>



            <div class="dropdown ">
                <a href="#" class="nav-link dropdown-toggle text-white" data-toggle="dropdown" role="button" aria-haspopup="true"  aria-expanded="false">
                    <i class="material-icons">content_cut</i> Cortadores
                </a>
                <ul class="dropdown-menu bg-light" role="menu">
                    <li>
                        <g:each in="${sx.security.UserRole.executeQuery("select l.user from UserRole l where l.role.authority='ROLE_CORTADOR'")}" var="row">

                        <g:link class="bg-light"  action="enProceso" id="${row.id}">
                            ${row.username}
                        </g:link>
                        </g:each>
                    </li>
                </ul>
            </div>



            <form class="form-inline ">
                <div class="col-md-2">
                    <input type='text' id="filtro"
                           placeholder="Filtrar" class="form-control" autofocus="on">
                </div>
            </form>


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

<g:layoutBody/>

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

<script type="text/javascript">
        $(function(){

            $("table tbody").on('hover','tr',function(){
                $(this).toggleClass("info");
            });

            $(".table tbody tr").hover(function(){
                $(this).toggleClass("info");
            });

            $("#filtro").on('keyup',function(e){
                $('#grid').DataTable().search(
                $(this).val()
                ).draw();
            });
        });

    </script>




</body>
</html>