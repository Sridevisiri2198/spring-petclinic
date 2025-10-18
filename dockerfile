FROM eclipse-temurin:25-jdk-jammy
ADD spring-petclinic-3.5.0-SNAPSHOT.jar springpet.jar
WORKDIR /springpet
EXPOSE 8080
CMD ["java", "-jar", "springpet.jar"]