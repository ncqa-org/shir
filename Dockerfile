FROM mcr.microsoft.com/windows/servercore:ltsc2019
ARG INSTALL_JDK=false

# Download the latest self-hosted integration runtime installer into the SHIR folder
COPY SHIR C:/SHIR/
ADD datavirtualityODBC.msi "C:\temp\"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#Copy installers
RUN 
    Start-Process 'msiexec' -ArgumentList '/i c:\temp\datavirtualityODBC.msi /quiet /norestart /log c:\temp\installodbc.log'; \
    Start-Sleep -s 30 ;\
    Remove-Item c:\temp\*.msi -force


RUN ["powershell", "C:/SHIR/build.ps1"]
ENTRYPOINT ["powershell", "C:/SHIR/setup.ps1"]

ENV SHIR_WINDOWS_CONTAINER_ENV True

HEALTHCHECK --start-period=120s CMD ["powershell", "C:/SHIR/health-check.ps1"]
