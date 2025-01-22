# Use o JDK 21 no Maven
FROM maven:3.9.2-eclipse-temurin-21 AS build
WORKDIR /app

# Copia os arquivos necessários
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:resolve

# Copia o código-fonte e faz o build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Use o JRE 21 na execução
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
