FROM mcr.microsoft.com/dotnet/core/runtime:3.1.9-buster-slim-arm32v7

WORKDIR /app

COPY program/bin/Release/netcoreapp3.0/ .

CMD ["./program"]