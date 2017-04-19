FROM microsoft/dotnet:1.1.1-sdk

EXPOSE 5000

WORKDIR /srv
RUN apt-get update && apt-get -y install git sqlite3 && rm -rf /var/lib/apt/lists/*
RUN git clone http://git.giraf.cs.aau.dk/Giraf17-Rest/web-api

WORKDIR /srv/web-api/GirafRest/
RUN dotnet restore
RUN dotnet build

ENTRYPOINT ["dotnet", "run"]
