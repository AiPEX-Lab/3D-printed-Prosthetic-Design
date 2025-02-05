# AUTHOR: Chukwuemeka L. Nkama
# Date: 1/27/2024

# Name of video
VID=$1

# Define training of environmental variables
EXPERIMENT="${VID%.*}"
GROUP=example_group
NAME=example_name
CONFIG=projects/neuralangelo/configs/custom/${EXPERIMENT}.yaml
GPUS=1

# set environmental variables
EXPERIMENT=${EXPERIMENT}
GROUP=${GROUP}
NAME=${NAME}
CONFIG=${CONFIG} 
GPUS=${GPUS}

# Train the model
nohup torchrun --nproc_per_node=${GPUS} train.py \
    --logdir=logs/${GROUP}/${NAME} \
    --config=${CONFIG} \
    --show_pbar & 

# Get PID of training process
PID=$!

# wait for training to finish
wait $PID


# Get the best model
max_num=0
best_mod=""

# Go through all the checkpoint files
for model in logs/${GROUP}/${NAME}/epoch_*_checkpoint.pt; do
  model_num=$(echo $model | cut -d'_' -f4)

  # update max_num
  if ((10#$model_num > max_num));then
    max=$model_num
    best_mod=$model
  fi
done


# Definition of environmental variables for extraction
CHECKPOINT=${best_mod}
RESOLUTION=2048
BLOCK_RES=128
OUTPUT_MESH=logs/${GROUP}/${NAME}/mesh_${EXPERIMENT}.ply
CONFIG=logs/${GROUP}/${NAME}/config.yaml


# Extract the mesh
nohup torchrun --nproc_per_node=${GPUS} projects/neuralangelo/scripts/extract_mesh.py \
    --config=${CONFIG} \
    --checkpoint=${CHECKPOINT} \
    --output_file=${OUTPUT_MESH} \
    --resolution=${RESOLUTION} \
    --block_res=${BLOCK_RES} & 

EXT_PID=$! # extraction PID

# wait for extraction to finish
wait $EXT_PID

# Postprocess the mesh
MESH_PATH=logs/${GROUP}/${NAME}/mesh_${EXPERIMENT}.ply
nohup python3 processor.py --path ${MESH_PATH} & 
POST_PID=$! # post-processing PID

# wait for post-processing to run completely
wait $POST_PID

# Final mesh gotten
echo "Final processed mesh generated!"
