# -------- Build Stage --------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY AZ2003.csproj ./
RUN dotnet restore

# Copy remaining files
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# -------- Runtime Stage --------
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copy from build stage
COPY --from=build /app/publish .

# Set port (important for Azure)
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Run app
ENTRYPOINT ["dotnet", "AZ2003.dll"]
