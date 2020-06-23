FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
#ENV API-proj-name Keeper.API
#ENV API-proj-path Keeper.API/Keeper.API.csproj
#ENV Data-proj-path Keeper.Data/Keeper.Data.csproj

WORKDIR /app

COPY ./Keeper.API/Keeper.API.csproj ./Keeper.API/Keeper.API.csproj
COPY ./Keeper.Data/Keeper.Data.csproj ./Keeper.Data/Keeper.Data.csproj
RUN dotnet restore ./Keeper.API

COPY . ./
RUN dotnet publish -c Release -o out ./Keeper.API

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "Keeper.API.dll"]