FROM mcr.microsoft.com/windows/servercore:ltsc2019
ARG INSTALL_JDK=false

# Download the latest self-hosted integration runtime installer into the SHIR folder
COPY SHIR C:/SHIR/

#Install ODBC DataVirtuality Driver
RUN Write-Host 'Downloading ODBC Driver' ; \  
    $MsiFile = $env:Temp + '\datavirtualityODBC.msi' ; \
    (New-Object Net.WebClient).DownloadFile('https://github.com/ncqa-org/shir/blob/main/SHIR/datavirtualityODBC.msi', $MsiFile) ; \
    Write-Host 'Installing ODBCDriver' ; \
    Start-Process msiexec.exe -ArgumentList '/i', $MsiFile, '/quiet', '/norestart' -NoNewWindow -Wait


#Build
RUN ["powershell", "C:/SHIR/build.ps1"]

#Install SHIR
ENTRYPOINT ["powershell", "C:/SHIR/setup.ps1"]

ENV SHIR_WINDOWS_CONTAINER_ENV True

HEALTHCHECK --start-period=120s CMD ["powershell", "C:/SHIR/health-check.ps1"]
