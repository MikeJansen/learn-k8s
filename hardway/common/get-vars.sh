eval $(terraform -chdir=../step-03-provisioning output -json | \
  jq -r '{ 
    TF_CP_IPS: .cp_ips.value|join(" "), 
    TF_CP_IPS_LIST: .cp_ips.value|join(","), 
    TF_NODE_IPS: .node_ips.value|join(" "), 
    TF_NODE_IPS_LIST: .node_ips.value|join(","), 
    TF_STATIC_IP_LB: .static_ip_lb.value, 
    TF_PROJECT_ID: .project_id.value, 
    TF_NUM_CPS: .num_cps.value, 
    TF_NUM_NODES: .num_nodes.value 
  } | to_entries | .[] | .key + "=" + (.value|@sh)')
  
TF_CP_LIST=''
for (( IDX=0; IDX < TF_NUM_CPS; IDX++)); do
  TF_CP_LIST="$TF_CP_LIST cp$IDX"
done

TF_NODE_LIST=''
for (( IDX=0; IDX < TF_NUM_NODES; IDX++)); do
  TF_NODE_LIST="$TF_NODE_LIST node$IDX"
done

TF_COMPUTE_LIST="$TF_CP_LIST $TF_NODE_LIST"

K8S_CLUSTER_NAME=k8s-the-hard-way
