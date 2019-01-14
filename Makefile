all:
	docker build -t cryptorama .

run:
	docker run --rm -p 3000:3000 -ti cryptorama

clean:
	docker rm cryptorama
