# Use an official R base image from Docker Hub
FROM rocker/rstudio

# Set environment variable for RStudio password
ENV PASSWORD=eiSaez0ohZ8ahf0a

# Expose port for RStudio
EXPOSE 8787
