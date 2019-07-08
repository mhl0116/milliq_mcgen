#! /bin/bash

TAG=$1
STAG=v1

INDIR=/hadoop/cms/store/user/bemarsh/milliqan/milliq_mcgen/ntuples_${TAG}
mkdir -p logs

if [ ! -d $INDIR ]; then
    echo "ERROR: directory ${INDIR} does not exist"
    exit 1
fi

for MDIR in `ls -d $INDIR/m_*`; do
    for SDIR in `ls -d $MDIR/*`; do
        if [ ! -d $SDIR/postsim_$STAG ]; then
            continue
        fi
        for QDIR in `ls -d ${SDIR}/postsim_${STAG}/q_*`; do
            M=`basename $MDIR`
            S=`basename $SDIR`
            Q=`basename $QDIR`
            OUTDIR=/nfs-7/userdata/bemarsh/milliqan/milliq_mcgen/merged_sim/${TAG}_${STAG}/$M/$Q
            mkdir -p $OUTDIR
            echo nohup nice -n19 copyTree.py "\"$QDIR/*.root\"" $OUTDIR/$S.root
            nohup nice -n19 copyTree.py "$QDIR/*.root" $OUTDIR/$S.root &> logs/log_${M}_${Q}_${S}.txt &
        done
    done
    # wait
done
