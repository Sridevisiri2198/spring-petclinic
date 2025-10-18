FROM eclipse-temurin:25-jdk-jammy
ADD https://trialp1bjia.jfrog.io/artifactory/practicerepo-libs-release/spring-petclinic-3.5.0-SNAPSHOT.jar springpet.jar
WORKDIR /springpet
EXPOSE 8080
CMD ["java", "-jar", "springpet.jar"]