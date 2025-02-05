# AUTHOR: Chukwuemeka L. Nkama
# Date: 1/27/2024

# Build Colmap image if it does not exist
if [ -z "$(docker images -q colmap_img)" ]; then
  docker build -t colmap_img -f Dockerfile-colmap .
fi

# Build Neuralangelo image if it does not exist
if [ -z "$(docker images -q neural_img)" ]; then
  docker build -t neural_img -f Dockerfile-neuralangelo .
fi

# Define neuralangelo container
NEURAL="container_neuralangelo"
COLMAP="container_colmap"

# Name of video
VID=$1

# start colmap container
if [ "$(docker ps -aq -f name=${COLMAP})" ]; then
  # if container exists, start it
  docker start ${COLMAP}
else
  # if container doesn't exist, create it
  docker run -d --gpus all --ipc=host --name ${COLMAP} colmap_img tail -f /dev/null
fi

# Transfer video and get the colmap poses
docker cp ${VID} ${COLMAP}:/
docker cp ./colmap.sh ${COLMAP}:/
docker exec ${COLMAP} bash -c "source colmap.sh ${VID}"

# copy neuralangelo folder to current directory
docker cp ${COLMAP}:/neuralangelo .

# stop colmap container 
docker stop ${COLMAP}

# start neural container 
if [ "$(docker ps -aq -f name=${NEURAL})" ]; then
  # if container exists, start it
  docker start ${NEURAL}
else
  # if container doesn't exist, create it
  docker run -d --gpus all --ipc=host --name ${NEURAL} neural_img tail -f /dev/null
fi

# transfer neuralangelo directory to main training container
docker cp ./neuralangelo ${NEURAL}:/workspace/

# transfer preprocessing script 
docker cp ./preprocess.sh ${NEURAL}:/workspace/neuralangelo/projects/neuralangelo/scripts/

# transfer mesh processing script
docker cp ./processor.py ${NEURAL}:/workspace/neuralangelo/

# Delete neuralangelo directory
rm -rf ./neuralangelo

# Copy reconstruction script
docker cp ./reconstruct.sh ${NEURAL}:/workspace/neuralangelo/

# Train the model and extract the mesh
docker exec --workdir /workspace/neuralangelo ${NEURAL} bash -c "source reconstruct.sh ${VID}"

# wait for mesh to be generated
DONE_PID=$!
wait $DONE_PID

# Copy final mesh
RESULT_MESH="res.ply"
workdir="/workspace/neuralangelo"

if docker exec -w $workdir ${NEURAL} test -e ${RESULT_MESH}; then
  # Check if the final file exists
  docker cp ${NEURAL}:$workdir/$RESULT_MESH .
  echo "Final mesh has been copied to the current working directory."
else
  echo "Final mesh does not exist in the container."
fi
