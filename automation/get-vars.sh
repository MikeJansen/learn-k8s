eval $(terraform -chdir=./terraform output -json gcp | \
  jq -r '{ 
    K_CP_IPS: .cp_ips|join(" "), 
    K_CP_IPS_LIST: .cp_ips|join(","), 
    K_WORKER_IPS: .worker_ips|join(" "), 
    K_WORKER_IPS_LIST: .worker_ips|join(","), 
    K_STATIC_IP_LB: .static_ip_lb, 
    K_PROJECT_ID: .project_id, 
    K_NUM_CPS: .num_cps, 
    K_NUM_WORKERS: .num_workers,
    K_POD_CIDR: .pod_cidr_base,
    K_SERVICE_CIDR: .service_cidr_base,
    K_SERVICE_IP: .service_ip,
    K_CLUSTER_DNS_IP: .cluster_dns_ip,
    K_POD_NODE_CIDRS: .pod_node_cidrs|join(" "),
    K_REGION: .region,
    K_ZONE: .zone,
    K_ZONES: .zones|join(" "),
    K_ZONE_LIST: .zones.join(",")
  } | to_entries | .[] | "export " + .key + "=" + (.value|@sh)')
  
CP_LIST=()
for (( IDX=0; IDX < K_NUM_CPS; IDX++)); do
  CP_LIST+=("cp$IDX")
done
_CP_LIST=$(IFS=' ' ; echo "${CP_LIST[*]}")

WORKER_LIST=()
for (( IDX=0; IDX < TF_NUM_WORKERS; IDX++)); do
  WORKER_LIST+=("worker$IDX")
done
export K_WORKER_LIST=$(IFS=' ' ; echo "${WORKER_LIST[*]}")

export K_COMPUTE_LIST="$K_CP_LIST $K_WORKER_LIST"

K_POD_NODE_CIDRS_ARRAY=()
for cidr in $TF_POD_NODE_CIDRS; do
  K_POD_NODE_CIDRS_ARRAY+=($cidr)
done
export K_POD_NODE_CIDRS_ARRAY
export K_CLUSTER_NAME=k8s-cluster
