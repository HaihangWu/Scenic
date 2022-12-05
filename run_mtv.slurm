#!/bin/bash
# The project ID which this job should run under:
#SBATCH --account="punim0512"

# The name of the job:
#SBATCH --job-name="example.py"

# Partition for the job:
# -p gpu-a100

#SBATCH --partition deeplearn
#SBATCH --qos gpgpudeeplearn

# Request different amount of resources for different nodes
#SBATCH --constraint=[dlg1|dlg2|dlg3|dlg4]
# --constraint=dlg4
#SBATCH --nodes=1                # node count
#SBATCH --ntasks-per-node=1      # total number of tasks per node
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --cpus-per-task=8        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=8G

# Maximum number of tasks/CPU cores used by the job:
# --ntasks=4
# --gpus-per-task=1  # number of gpus per task

# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=03-00:00:0

# Send yourself an email when the job:
#SBATCH --mail-user=robotic.engineer.dylan.wu@gmail.com
#SBATCH --mail-type=BEGIN,FAIL,END

module load anaconda3/2021.11
eval "$(conda shell.bash hook)"
conda deactivate
conda activate mtv-1


#source /usr/local/module/spartan_new.sh
#module load fosscuda/2019b
#module load gcc/8.3.0 cuda/10.1.243 openmpi/3.1.4
#module load python/3.7.4
#module load tensorflow/2.3.1-python-3.7.4

# The job command(s):
export MASTER_PORT=$(expr 20000 + $(echo -n $SLURM_JOBID | tail -c 4))
export WORLD_SIZE=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))
echo "WORLD_SIZE="$WORLD_SIZE

master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr
echo "MASTER_PORT="$MASTER_PORT
echo "MASTER_ADDR="$MASTER_ADDR
echo "r$SLURM_NODEID Launching python script"

srun python -m scenic.projects.mtv.main \
  --config=scenic/projects/mtv/configs/kinetics/k400_mtv_b2_cva.py \
  --workdir=mtv_base_cva/ >> mtv.txt


#srun python test.py --batch-size 1024 --train-steps 200000 --device gpu >> test.txt
