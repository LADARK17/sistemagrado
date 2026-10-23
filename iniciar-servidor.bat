@echo off
set "CATALINA_HOME=C:\xampp\tomcat"
set "CATALINA_BASE=C:\xampp\tomcat"
set "JAVA_HOME=C:\jdk-26_windows-x64_bin\jdk-26.0.2.1"
set "JRE_HOME=C:\jdk-26_windows-x64_bin\jdk-26.0.2.1"

echo ========================================================
echo Sincronizando archivos del proyecto a Tomcat...
echo ========================================================
robocopy "%~dp0web" "%CATALINA_HOME%\webapps\Sistema-proyectos" /E /XO /NP /NFL /NDL /NJH /NJS

echo ========================================================
echo Iniciando Apache Tomcat en http://localhost:8080/Sistema-proyectos
echo ========================================================
"%CATALINA_HOME%\bin\catalina.bat" run
