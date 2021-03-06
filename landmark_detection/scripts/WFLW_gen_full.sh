#!/usr/bin/env sh

echo script name: $0
echo $# arguments
if [ "$#" -ne 3 ] ;then
  echo "Input illegal number of parameters " $#
  echo "Need 3 parameters for gpu devices and detector and sigma"
  exit 1
fi
gpus=$1
model=itn_cpm
epochs=100
stages=3
batch_size=8
GPUS=1
sigma=4
height=128
width=128
dataset_name=WFLW_gen_full

CUDA_VISIBLE_DEVICES=${gpus} python san_main.py \
    --train_list /home/sjqian/Data/WFLW/wflw_train_98pt.txt \
                 /home/sjqian/Data/full/WFLW_full/output/san_all_98pt.txt \
    --eval_lists /home/sjqian/Data/WFLW/wflw_test_98pt.txt \
    --cycle_a_lists ./snapshots/CLUSTER-300W_$2-3/cluster-00-03.lst \
    --cycle_b_lists ./snapshots/CLUSTER-300W_$2-3/cluster-02-03.lst \
    --cycle_model_path ./snapshots/SAN_300W_GTB_itn_cpm_3_50_sigma4_128x128x8/cycle-gan/itn-epoch-200-201 \
    --num_pts 98 --pre_crop_expand 0.2 \
    --arch ${model} --cpm_stage ${stages} \
    --save_path ./snapshots/SAN_${dataset_name}_${model}_${stages}_${epochs}_sigma${sigma}_${height}x${width}x8 \
    --learning_rate 0.0000 --decay 0.0005 --batch_size ${batch_size} --workers 20 --gpu_ids 4 \
    --epochs ${epochs} --schedule 30 35 40 45 --gammas 0.5 0.5 0.5 0.5 \
    --dataset_name ${dataset_name} \
    --scale_min 1 --scale_max 1 --scale_eval 1 --eval_batch ${batch_size} \
    --crop_height ${height} --crop_width ${width} --crop_perturb_max 30 \
    --sigma ${sigma} --print_freq 50 --print_freq_eval 100 --pretrain \
    --evaluation --heatmap_type gaussian --argmax_size 3 \
    --epoch_count 1 --niter 100 --niter_decay 100 --cycle_batchSize 1 --identity 0.1 \
    --cycle_batchSize 32
