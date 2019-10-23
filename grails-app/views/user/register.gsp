%{--
- Copyright (c) 2019 Kagilum SAS
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Nicolas Noullet (nnoullet@kagilum.com)
--}%
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>${message(code: 'is.login')}</title>
        <meta name='layout' content='simple-without-ng'/>
    </head>
    <body>
        <div class="not-logged-in container-left-top-yellow-rect container-left-bottom-blue-rect" style="height: 100vh">
            <div class="d-flex justify-content-center content row">
                <div class="rect_1"></div>
                <div class="rect_2"></div>
                <div class="rect_3"></div>
                <div class="register" style="max-width:600px;">
                    <div class="text-center">
                        <a href="https://www.icescrum.com" target="_blank">
                            <img id="logo" alt="iceScrum" src="${assetPath(src: 'application/logo.png')}">
                            <img id="logo-name" src="${assetPath(src: 'application/icescrum.png')}" alt="iceScrum" class="img-fluid">
                        </a>
                    </div>
                    <form action='${postUrl}' name="loginform" id="loginform" class="form-special" method="post" autocomplete='off'>
                        <div class="text-center login-footer">
                            <div class="login-cta-text">Already have an account</div>
                            <g:link class="btn btn-secondary" action="auth" controller="login">${message(code: 'is.login')}</g:link>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>