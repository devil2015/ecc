#!/bin/bash

REPO1=gitlab@ellyptech.ddns.net:abhisheietk/integration.git
REPO2=gitlab@ellyptech.ddns.net:abhisheietk/infra.git
NAME1=integration
NAME2=infra

git clone ${REPO1}
mkdir ${NAME1}
pushd ${NAME1}
git mv * ${NAME1}
git commit -a -m "Move."
git remote add origin-${NAME2} ${REPO2}
git fetch origin-${NAME2}
git branch merge-${NAME2} origin-${NAME2}/master
mkdir ${NAME2}
git checkout master
git mv * ${NAME2}
git commit -a -m "Move."
git merge merge-${NAME2}
git branch -d merge-${NAME2}
git remote remove origin-${NAME2}
