FROM mcr.microsoft.com/windows/servercore:ltsc2019
ARG INSTALL_JDK=false

# Download the latest self-hosted integration runtime installer into the SHIR folder
COPY SHIR C:/SHIR/
ADD datavirtualityODBC.msi "C:\temp\"
RUN msiexec.exe C:\temp\datavirtualityODBC.msi /quiet /norestart
RUN ["powershell", "C:/SHIR/odbc.ps1"] 
ENTRYPOINT ["powershell", "C:/SHIR/odbc.ps1"] 
RUN ["powershell", "C:/SHIR/build.ps1"]
ENTRYPOINT ["powershell", "C:/SHIR/setup.ps1"]

ENV SHIR_WINDOWS_CONTAINER_ENV True

HEALTHCHECK --start-period=120s CMD ["powershell", "C:/SHIR/health-check.ps1"]
