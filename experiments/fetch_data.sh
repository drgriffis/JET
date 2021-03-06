#!/bin/bash


## Dataset files
UMNSRS_SIM=../data/experiments/simrel/UMNSRS/UMNSRS_similarity.csv
UMNSRS_REL=../data/experiments/simrel/UMNSRS/UMNSRS_relatedness.csv
UMNSRS_FILTER=../data/experiments/simrel/UMNSRS/UMNSRS_filtered_subset.skips
WIKISRS_SIM=../data/experiments/simrel/WikiSRS/WikiSRS_similarity.csv
WIKISRS_REL=../data/experiments/simrel/WikiSRS/WikiSRS_relatedness.csv

BMASS=../data/experiments/analogy/BMASS/BMASS_multi_answer.txt
GOOGLE=../data/experiments/analogy/Google/questions-words.txt

NLM_WSD=../data/experiments/entitylinking/NLM-WSD/nlm_wsd.mentions
NLM_WSD_DEFN=../data/experiments/entitylinking/NLM-WSD/entity_definitions.txt
AIDA=../data/experiments/entitylinking/AIDA/aida.mentions


## Miscellaneous data files
UMLS_2017AB_PREFSTRS=../data/terminologies/UMLS_2017AB/UMLS_2017AB_preferred_strings.tsv


## Baseline embedding files
BL_CHIU_2016=../data/embeddings/baselines/PubMed-shuffle-win-2.bin
BL_DEVINE_2014=../data/embeddings/baselines/DeVine_etal_2014.bin
BL_MENCIA_2016=../data/embeddings/baselines/Mencia_etal_2016.bin
BL_WIKI_MPME=../data/embeddings/wikipedia/MPME_baseline_bak.bin


# sim/rel results directories
if [ ! -d ../data/experiments/simrel/UMNSRS/results ]; then
    mkdir -p ../data/experiments/simrel/UMNSRS/results
fi
if [ ! -d ../data/experiments/simrel/WikiSRS/results ]; then
    mkdir -p ../data/experiments/simrel/WikiSRS/results
fi
# analogy results directories
if [ ! -d ../data/experiments/analogy/BMASS/results ]; then
    mkdir -p ../data/experiments/analogy/BMASS/results
fi
if [ ! -d ../data/experiments/analogy/Google/results ]; then
    mkdir -p ../data/experiments/analogy/Google/results
fi
# entity-linking results directories
if [ ! -d ../data/experiments/entitylinking/AIDA/results ]; then
    mkdir -p ../data/experiments/entitylinking/AIDA/results
fi
if [ ! -d ../data/experiments/entitylinking/NLM-WSD/results ]; then
    mkdir -p ../data/experiments/entitylinking/NLM-WSD/results
fi

# Sim/Rel :: download UMNSRS
if [ ! -e ${UMNSRS_SIM} ]; then
    echo "Downloading UMNSRS Similarity..."
    curl -o ${UMNSRS_SIM} http://rxinformatics.umn.edu/data/UMNSRS_similarity.csv
fi
if [ ! -e ${UMNSRS_REL} ]; then
    echo "Downloading UMNSRS Relatedness..."
    curl -o ${UMNSRS_REL} http://rxinformatics.umn.edu/data/UMNSRS_relatedness.csv
fi
if [ ! -e "${UMNSRS_FILTER}" ]; then
    echo "Downloading UMNSRS filter set..."
    curl -k -o ${UMNSRS_FILTER} https://slate.cse.ohio-state.edu/JET/data/UMNSRS_filtered_subset.skips
fi

# Sim/Rel :: download WikiSRS
if [ ! -e ${WIKISRS_SIM} ]; then
    echo "Downloading WikiSRS Similarity..."
    curl -k -o ${WIKISRS_SIM} https://slate.cse.ohio-state.edu/WikiSRS/WikiSRS_similarity.csv
fi
if [ ! -e ${WIKISRS_REL} ]; then
    echo "Downloading WikiSRS Relatedness..."
    curl -k -o ${WIKISRS_REL} https://slate.cse.ohio-state.edu/WikiSRS/WikiSRS_relatedness.csv
fi

# Analogy :: download BMASS
if [ ! -e ${BMASS} ]; then
    echo "Need to download BMASS biomedical analogy set."
    echo "File can be downloaded from this page:"
    echo "   https://slate.cse.ohio-state.edu/UTSAuthenticatedDownloader/index.html?dataset=BMASS"
    echo
    echo "Replication scripts only need the Multi-Answer file, and"
    echo "expect it to live in:"
    echo "   ${BMASS}"
    echo
    read -p "Press [Enter] to continue"
fi
# Analogy :: download Google analogies
if [ ! -e ${GOOGLE} ]; then
    echo "Downloading Google analogy set..."
    curl -k -o ${GOOGLE} https://slate.cse.ohio-state.edu/JET/data/questions-words.txt
fi

# Entity-linking :: download AIDA mentions
if [ ! -e ${NLM_WSD} ] || [ ! -e ${NLM_WSD_DEFN} ]; then
    echo "Need to download pre-generated NLM-WSD mention and CUI definition data."
    echo "File can be downloaded from link on this page:"
    echo "   https://slate.cse.ohio-state.edu/UTSAuthenticatedDownloader/index.html?dataset=NLM_WSD_JET.zip"
    echo
    echo "Replication scripts expect the files to live in:"
    echo "   ${NLM_WSD}"
    echo "   ${NLM_WSD_DEFN}"
    echo
    read -p "Press [Enter] to continue" 
fi
if [ ! -e ${AIDA} ]; then
    echo "Downloading AIDA mentions..."
    curl -k -o ${AIDA} https://slate.cse.ohio-state.edu/JET/data/aida.mentions
fi

# All :: download baselines
if [ ! -e "${BL_CHIU_2016}" ]; then
    echo "Need to download PubMed embeddings from Chiu et al. (2016)."
    echo "File can be downloaded from link on this page:"
    echo "   https://github.com/cambridgeltl/BioNLP-2016"
    echo
    echo "Replication scripts expect file to live in:"
    echo "   ${BL_CHIU_2016}"
    echo
    read -p "Press [Enter] to continue" ignore
fi
if [ ! -e "${BL_DEVINE_2014}" ]; then
    echo "Downloading UMLS CUI embeddings from DeVine et al. (2014)..."
    curl -k -o ${BL_DEVINE_2014} https://slate.cse.ohio-state.edu/JET/data/DeVine_etal_2014.bin
fi
if [ ! -e "${BL_MENCIA_2016}" ]; then
    echo "Downloading MeSH header CUI embeddings from Mencia et al. (2016)..."
    echo "Original data, mapped to MeSH header IDs, hosted here:"
    echo "   http://www.ke.tu-darmstadt.de/resources/medsim"
    echo "Downloading version pre-mapped to UMLS CUIs..."
    curl -k -o ${BL_MENCIA_2016} https://slate.cse.ohio-state.edu/JET/data/Mencia_etal_2016.bin
fi
if [ ! -e "${BL_WIKI_MPME}" ]; then
    echo "Whoops! Don't know how to get that one yet."
fi

# All :: download miscellaneous data
if [ ! -e "${UMLS_2017AB_PREFSTRS}" ]; then
    echo "Need to download preferred strings file for UMLS 2017AB."
    echo "File can be downloaded from link on this page:"
    echo "   https://slate.cse.ohio-state.edu/UTSAuthenticatedDownloader/index.html?dataset=UMLS_2017AB_preferred_strings"
    echo
    echo "Replication scripts expect file to live in:"
    echo "   ${UMLS_2017AB_PREFSTRS}"
    echo
    read -p "Press [Enter] to continue" ignore
fi
