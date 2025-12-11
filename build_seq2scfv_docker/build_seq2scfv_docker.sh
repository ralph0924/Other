#git clone https://github.com/ngs-ai-org/seq2scfv.git
git clone https://github.com/MikolajKocikowski/seq2scfv-unofficial-updated.git
cd seq2scfv-unofficial-updated/Docker
docker build -t seq2scfv .
docker run --rm -it seq2scfv bash
docker run --rm -u $(id -u):$(id -g) -it seq2scfv bash
docker ps -a
docker stop <container_id_or_name>

##############################################

docker run --rm -it \
  --user $(id -u):$(id -g) \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  seq2scfv bash
