# How to Deploy Hugging Face Models in a Docker Container

<!-- WARNING: THIS FILE WAS AUTOGENERATED! DO NOT EDIT! -->

## Install

To use the translation service, you need to have Docker installed. The
best way to install it is by installing [Docker
Desktop](https://www.docker.com/products/docker-desktop/) of your local
computer.

The next step is to clone this repository:

``` sh
git clone https://github.com/fgiasson/literate-en-fr-translation-service.git
```

Finally, you only have to run this `Make` command to build the Docker
image:

``` sh
make build
```

That will create the Docker image from which you will be able to create
a container using Docker Decktop.

Refer to [this blog
post](https://fgiasson.com/blog/index.php/2023/08/23/how-to-deploy-hugging-face-models-in-a-docker-container/)
for detailed information about how it works.

# How to use

## Web Service Endpoints

Once you have the container running, you can use the web service
endpoints to translate text from English to French and vice-versa. The
two endpoints are:

- `/translate/en/fr`
- `/translate/fr/en`

Then you can test the web service endpoints using `curl`:

``` bash
curl http://localhost:6000/translate/en/fr/ POST -H "Content-Type: application/json" -d '{"en_text":"Hello World!"}'
```

The output should be:

``` json
{
  "fr_text": "Bonjour le monde!"
}
```

``` bash
curl http://localhost:6000/translate/fr/en/ POST -H "Content-Type: application/json" -d '{"fr_text":"Bonjour le monde!"}'
```

The output should be:

``` json
{
  "en_text": "Hello world!"
}
```
