region="us-east-1"

vpc_cidr="172.24.1.0/24"
subnet_public_cidr_list=["172.24.1.0/27","172.24.1.32/27"]
subnet_private_cidr_list=["172.24.1.64/27","172.24.1.96/27"]
subnet_nat_cidr_list=["172.24.1.128/27","172.24.1.160/27"]
availability_zones_list=["us-east-1a","us-east-1b"]

vpc_name="PA-VPC-D-UE1-N-001"
internet_gateway_name="PA-IGW-D-UE1-N-001"
subnet_nat_name_list=["PA-SNT-D-UE1-N-A-NT-D-001","PA-SNT-D-UE1-N-B-NT-D-001"]
subnet_public_name_list=["PA-SNT-D-UE1-N-A-PB-D-001","PA-SNT-D-UE1-N-B-PB-D-001"]
subnet_private_name_list=["PA-SNT-D-UE1-N-A-PR-D-001","PA-SNT-D-UE1-N-B-PR-D-001"]
route_nat_name_list=["PA-RTB-D-UE1-N-A-NT-D-001","PA-RTB-D-UE1-N-B-NT-D-001"]
route_public_name_list=["PA-RTB-D-UE1-N-A-PB-D-001","PA-RTB-D-UE1-N-B-PB-D-001"]
route_private_name_list=["PA-RTB-D-UE1-N-A-PR-D-001","PA-RTB-D-UE1-N-B-PR-D-001"]
eip_name_list=["PA-EIP-D-UE1-N-A-D-001","PA-EIP-D-UE1-N-B-D-001"]
nat_name_list=["PA-NGW-D-UE1-N-A-D-001","PA-NGW-D-UE1-N-B-D-001"]
vpc_peer_requester_name="PA-VPR_PA-VPC-D-UE1-N-001"
public_nacl_name="PA-NAC-D-UE1-N-PB-D-001"
nat_nacl_name="PA-NAC-D-UE1-N-NT-D-001"
private_nacl_name="PA-NAC-D-UE1-N-PB-D-001"
cloudwatch_flow_log_name="PA-CLG-D-N-FLWL-001"
iam_flowlog_role_name="PA-ROL-IS-VPC-FLOWLOG"
iam_flowlog_policy_name="PA-POL-IS-VPC-FLOWLOG"
iam_aws_config_role_name="PA-ROL-IS-CFG-CONFIG"
aws_config_recorder_name="aws_config_recorder"