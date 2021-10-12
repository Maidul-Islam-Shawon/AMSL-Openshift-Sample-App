#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["AMSL-Sample-Proj.csproj", "."]
RUN dotnet restore "./AMSL-Sample-Proj.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AMSL-Sample-Proj.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AMSL-Sample-Proj.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AMSL-Sample-Proj.dll"]