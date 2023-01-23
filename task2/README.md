To organize a terraform project that could interact with many cloud providers and different environments, 
I would create two sub folders one for each cloud (for example "GCP" and "AWS" and inside modules for each components 

then have a folder per environments containers a tf file with variables 

and also a main.tf file per cloud provider and not forget to specfy a backend to store remotely the tf state 