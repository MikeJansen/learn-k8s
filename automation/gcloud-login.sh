if [[ -f "$K_ACCOUNT_KEY" ]]; then
    echo 'Activating service credentials'

    gcloud auth activate-service-account --key-file=$K_ACCOUNT_KEY || exit 1
    export GOOGLE_APPLICATION_CREDENTIALS=$(realpath $K_ACCOUNT_KEY)
fi
