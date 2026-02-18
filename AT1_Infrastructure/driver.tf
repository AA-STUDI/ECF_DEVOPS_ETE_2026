locals {
    oidc_issuer = module.eks.oidc_provider # récupération de l'issuer OIDC du cluster
}

resource "aws_iam_role" "ebs_csi" {
    name = "AmazonEKS_EBS_CSI_DriverRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = { Federated = module.eks.oidc_provider_arn }
            Action = "sts:AssumeRoleWithWebIdentity"
            Condition = {
                StringEquals = {
                    "${local.oidc_issuer}:aud" = "sts.amazonaws.com"
                    "${local.oidc_issuer}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
                }
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
    role       = aws_iam_role.ebs_csi.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_eks_addon_version" "ebs_csi" {
    addon_name         = "aws-ebs-csi-driver"
    kubernetes_version = module.eks.cluster_version
    most_recent        = true
}

resource "aws_eks_addon" "ebs_csi" {
    cluster_name             = module.eks.cluster_name
    addon_name               = "aws-ebs-csi-driver"
    addon_version            = data.aws_eks_addon_version.ebs_csi.version
    service_account_role_arn = aws_iam_role.ebs_csi.arn
}
