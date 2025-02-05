# AUTHOR: Chukwuemeka L. Nkama
# Date: 1/27/2024

git clone https://github.com/NVlabs/neuralangelo.git
cd ./neuralangelo/
git submodule update --init --recursive # init colmap submodule

# Name of video
VID=$1

# move video to neuralangelo directory
cp ../${VID} .

# Define environmental variables
SEQUENCE="${VID%.*}"
PATH_TO_VIDEO=${VID}
DOWNSAMPLE_RATE=2
SCENE_TYPE=object

# Extract Colmap poses
nohup bash projects/neuralangelo/scripts/preprocess.sh ${SEQUENCE} ${PATH_TO_VIDEO} ${DOWNSAMPLE_RATE} ${SCENE_TYPE} & 

# Get PID of training process
PID=$!

# Wait for process to run finish
wait $PID
