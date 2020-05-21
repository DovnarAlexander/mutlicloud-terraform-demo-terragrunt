#!/usr/bin/env python
from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import InternetGateway
from diagrams.gcp.network import NAT
from diagrams.gcp.compute import GCE
from diagrams.azure.compute import VMLinux
from diagrams.azure.network import VirtualNetworkGateways
from diagrams.oci.edge import DnsGrey

with Diagram("Multi-Cloud environment", show=False):
  with Cluster("Amazon VPC"):
    aws = InternetGateway("IntenetGateway")
    aws_app = EC2("Application")
    aws - aws_app
  with Cluster("GCP VPC"):
    gcp = NAT("NAT Gateway")
    gcp_lb = (gcp - GCE("HAProxy"))
    gcp_app = GCE("Application")
    gcp - gcp_app
  with Cluster("Azure VPC"):
    azure = VirtualNetworkGateways("Virtual Gateway")
    azure_app = VMLinux("Application")
    azure - azure_app
  with Cluster("CloudFlare"):
    dns = DnsGrey("DNS")
  dns >> Edge(style="invis") >> gcp
  dns >> Edge(style="invis") >> aws
  dns >> Edge(style="invis") >> azure
  dns >> Edge(color="firebrick", style="dashed") >> gcp_lb
  gcp_lb >> Edge(color="firebrick", style="dashed") >> aws_app
  gcp_lb >> Edge(color="firebrick", style="dashed") >> gcp_app
  gcp_lb >> Edge(color="firebrick", style="dashed") >> azure_app
