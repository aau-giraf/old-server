FROM microsoft/dotnet:1.1-sdk

WORKDIR /srv
RUN apt-get update && apt-get -y install git sqlite3 && rm -rf /var/lib/apt/lists/*
RUN git clone http://git.giraf.cs.aau.dk/Giraf17-Rest/web-api

WORKDIR /srv/web-api/GirafWebApi/GirafWebApi/
RUN dotnet restore
RUN dotnet build

ENTRYPOINT ["dotnet", "run"]
CMD ["-localdb"]
