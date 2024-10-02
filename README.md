# What The Hack - Microservices in Azure

## Introduction

This hack is intended to teach how to host, operate, and monitor Azure workloads running microservices. During this hack you will be working in Azure App Services,  CosmosDB, and Application Insights.

This hack includes a [lecture slide deck](Slides/Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

## Learning Objectives

1. Build technical skills for deploying, operating, and monitoring workloads in Azure
2. Understand different Azure Services that can be employed in a microservices architecture.

## Challenges

- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Student/Challenge-00.md)**
  - A smart cloud solution architect always has the right tools in their toolbox. 
- Challenge 1: **[First Thing is First - A Resource Group](Student/Challenge-01.md)**
  - All work in Azure begins with the resource group.
- Challenge 2: **[Always Need App Insights](Student/Challenge-02.md)**
  - Getting Application Insights turned on and used by default.
- Challenge 3: **[Get Some Data](Student/Challenge-03.md)**
  - Setting up Cosmos DB as our data store.
- Challenge 4: **[Deploying containers to App Service](Student/Challenge-04.md)**
  - Deploying our back-end microservices as web apps.
- Challenge 5: **[Deploy the Website](Student/Challenge-05.md)**
  - Deploying our front-end microservice as a container web app running on Linux App Services

## Prerequisites

- Your own Azure subscription with Owner access
- Azure CLI (or Cloud Shell)

## Application architecture

![alt text](image.png)

## Repository Contents

- `../Slides`
  - [Lecture presentation](Slides/Lectures.pptx) with short presentations to introduce each challenge.
  - Example solutions to the challenges 
- `../Script/`
  - Code for the microservices and a packaging script to publish the containers to Docker Hub.
- `../Resources`
  - Sample template to aid with challenges.

