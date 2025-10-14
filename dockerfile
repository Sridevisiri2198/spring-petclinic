FROM eclipse-temurin:17-jdk-jammy
ADD https://trialp1bjia.jfrog.io/ui/repos/tree/General/heavenrepo-libs-release/spring-petclinic-3.5.0-SNAPSHOT.jar springpet.jar
WORKDIR /springpet
EXPOSE 8080
CMD ["java", "-jar", "springpet.jar"]