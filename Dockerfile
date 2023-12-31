FROM mcr.microsoft.com/windows/servercore:ltsc2019
ARG INSTALL_JDK=false

# Download the latest self-hosted integration runtime installer into the SHIR folder
COPY SHIR C:/SHIR/

#Install ODBC DataVirtuality Driver

WORKDIR  C:\\SHIR

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Start-Process 'C:\SHIR\datavirtualityANSI_x64.msi' '/quiet /norestart' -PassThru | Wait-Process;


#Build
RUN ["powershell", "C:/SHIR/build.ps1"]

#Install SHIR
ENTRYPOINT ["powershell", "C:/SHIR/setup.ps1"]

ENV SHIR_WINDOWS_CONTAINER_ENV True

HEALTHCHECK --start-period=120s CMD ["powershell", "C:/SHIR/health-check.ps1"]
