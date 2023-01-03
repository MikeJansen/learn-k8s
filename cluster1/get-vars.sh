eval $(terraform -chdir=./terraform output -json | \
  jq -r '{ 
    K_CP_IPS: .cp_ips.value|join(" "), 
    K_CP_IPS_LIST: .cp_ips.value|join(","), 
    K_CP0_IP: .cp_ips.value[0],
    K_WORKER_IPS: .worker_ips.value|join(" "), 
    K_WORKER_IPS_LIST: .worker_ips.value|join(","), 
    K_STATIC_IP_LB: .static_ip_lb.value, 
    K_PROJECT_ID: .project_id.value, 
    K_NUM_CPS: .num_cps.value, 
    K_NUM_WORKERS: .num_workers.value,
    K_POD_CIDR: .pod_cidr_base.value,
    K_SERVICE_CIDR: .service_cidr_base.value,
    K_SERVICE_IP: .service_ip.value,
    K_CLUSTER_DNS_IP: .cluster_dns_ip.value,
    K_POD_NODE_CIDRS: .pod_node_cidrs.value|join(" "),
    K_REGION: .region.value,
    K_ZONE: .zone.value,
    K_ZONES: .zones.value|join(" "),
    K_ZONE_LIST: .zones.value|join(",")
  } | to_entries | .[] | "export " + .key + "=" + (.value|@sh)')
  
CP_LIST=()
for (( IDX=0; IDX < K_NUM_CPS; IDX++)); do
  CP_LIST+=("cp$IDX")
done
export K_CP_LIST=$(IFS=' ' ; echo "${CP_LIST[*]}")

WORKER_LIST=()
for (( IDX=0; IDX < K_NUM_WORKERS; IDX++)); do
  WORKER_LIST+=("worker$IDX")
done
export K_WORKER_LIST=$(IFS=' ' ; echo "${WORKER_LIST[*]}")

export K_COMPUTE_LIST="$K_CP_LIST $K_WORKER_LIST"

K_POD_NODE_CIDRS_ARRAY=()
for cidr in $K_POD_NODE_CIDRS; do
  K_POD_NODE_CIDRS_ARRAY+=($cidr)
done
export K_POD_NODE_CIDRS_ARRAY
export K_CLUSTER_NAME=k8s-cluster

set|grep ^K_ --color=never | sed 's/^/export /' > k_vars.sh
