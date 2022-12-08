eval $(terraform -chdir=../step-03-provisioning output -json gcp | \
  jq -r '{ 
    TF_CP_IPS: .cp_ips|join(" "), 
    TF_CP_IPS_LIST: .cp_ips|join(","), 
    TF_NODE_IPS: .node_ips|join(" "), 
    TF_NODE_IPS_LIST: .node_ips|join(","), 
    TF_STATIC_IP_LB: .static_ip_lb, 
    TF_PROJECT_ID: .project_id, 
    TF_NUM_CPS: .num_cps, 
    TF_NUM_NODES: .num_nodes,
    TF_POD_CIDR: .pod_cidr_base,
    TF_SERVICE_CIDR: .service_cidr_base,
    TF_SERVICE_IP: .service_ip,
    TF_CLUSTER_DNS_IP: .cluster_dns_ip,
    TF_POD_NODE_CIDRS: .pod_node_cidrs|join(" ")
  } | to_entries | .[] | .key + "=" + (.value|@sh)')
  
CP_LIST=()
for (( IDX=0; IDX < TF_NUM_CPS; IDX++)); do
  CP_LIST+=("cp$IDX")
done
TF_CP_LIST=$(IFS=' ' ; echo "${CP_LIST[*]}")

NODE_LIST=()
for (( IDX=0; IDX < TF_NUM_NODES; IDX++)); do
  NODE_LIST+=("node$IDX")
done
TF_NODE_LIST=$(IFS=' ' ; echo "${NODE_LIST[*]}")

TF_COMPUTE_LIST="$TF_CP_LIST $TF_NODE_LIST"

TF_POD_NODE_CIDRS_ARRAY=()
for cidr in $TF_POD_NODE_CIDRS; do
  TF_POD_NODE_CIDRS_ARRAY+=($cidr)
done

K8S_CLUSTER_NAME=k8s-the-hard-way
