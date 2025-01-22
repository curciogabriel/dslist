# Etapa 1: Construção do projeto
FROM maven:3.9.2-eclipse-temurin-21 AS build

# Define o diretório de trabalho no container
WORKDIR /app

# Copia o arquivo pom.xml e os arquivos do Maven Wrapper
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Baixa as dependências do Maven (faz cache delas)
RUN ./mvnw dependency:resolve

# Copia todo o código-fonte do projeto para o container
COPY src ./src

# Compila o projeto e gera o JAR final
RUN ./mvnw clean package -DskipTests

# Etapa 2: Runtime (executar o projeto)
FROM eclipse-temurin:17-jre

# Define o diretório de trabalho
WORKDIR /app

# Copia o JAR gerado na etapa de build
COPY --from=build /app/target/*.jar app.jar

# Exponha a porta usada pela aplicação
EXPOSE 8080

# Define o comando para executar a aplicação
CMD ["java", "-jar", "app.jar"]
