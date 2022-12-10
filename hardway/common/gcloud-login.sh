if [[ -f '../../k8s-hardway.json' ]]; then
    echo 'Activating service credentials'

    gcloud auth activate-service-account --key-file=../../k8s-hardway.json
    export GOOGLE_APPLICATION_CREDENTIALS=$(realpath ../../k8s-hardway.json)
fi

