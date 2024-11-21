workspace "Azure VM Deploy" "A Deployment Engine for Deploying a VM to Azure using GitHub Actions and Terraform" {

    !identifiers hierarchical
    !docs docs

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }

        # group Tenant {
        # ss = softwareSystem <name> [description] [tags]     
        iam = softwareSystem "IAM" "Identity and Access Management" iamtag {
            # container <name> [description] [technology] [tags]
            svc_tfuser = container "svc-tfuser" "Terraform User" "service account" serviceaccounttag
            contributor = container "contributor" "Scoped Rights" "permissions" contributorroletag {
                -> svc_tfuser "assign scope" subscription
            }
        }
        group IaC {
            terraform = softwareSystem "Terraform" "Deployment Automation" terraformtag {
                cloudformation = container "Cloud Formation" "another thing" cloudformationtag
                tfstate = container "TFState" "Terraform State" "storage" tfstatetag
            }     
        }

        group vm_system {
            vpc = softwareSystem "VPC" "Virtual Network" vpctag {
                nic = container NIC "Network Interface Card" "connector" nictag
                sg = container NSG "Network Security Group" "filter" sgtag {
                    -> nic filtered
                }
                eip = container EIP "Public IP Address" "address" eiptag {
                    -> sg forward
                }
            }
            vm = softwareSystem "Azure VM" "Azure VM" vmtag {
                osdisk = container "OSDisk" "VM Disk" "storage" osdisktag
                dockerhost = container "Docker Host" "Docker Host" docker dockertag {
                    -> vm.osdisk "file system"
                    vpc.nic -> this attached
                }
            }
        }

        dns = softwareSystem "DNS" "Domain Name Service" dnstag
        clientbrowser = softwareSystem "Client Browser" "lookup" clientbrowsertag {
            -> dns lookup
            -> vpc.eip connect
        }
        github = softwareSystem "GitHub" "Code Repository" githubtag {
            ghactions = container "GitHub Actions" "Automation" "deploy" ghactionstag {
                -> iam.svc_tfuser "service account" authentication
                -> terraform.cloudformation terraform automation
                -> terraform.tfstate "terraform state" persistence
            }
        }
    }

    views {
        systemContext vm "EC2VM" "AWS VM" {
            include *
            include vpc
            include terraform
            include clientbrowser
        }
        # container activedirectory "AzureAD" "Azure Active Directory" {
        #     include *
        # }
        # container azurecompute "AzureCompute" "Azure Compute" {
        #     include *
        # }
        # container azurenetwork "AzureNetwork" "Azure Network" {
        #     include *
        #     include azurecompute
        #     include clientbrowser
        #     include dns
        # }
        # container azurestorage "AzureStorage" "Azure Storage" {
        #     include *
        #     include azurecompute
        #     include github
        # }
        container github "GitHub" "CI/CD" {
            include *
        }
    
        styles {
            relationship "Relationship" {
                # color green
                dashed false
                thickness 3
                fontSize 30
            }
            element clientbrowsertag {
                background DarkSeaGreen
                color black
                shape WebBrowser
                icon docs/icons/browser.png
            }
            # AD Styles
            element activedirectorytag {
                background IndianRed
                color white
                # height 250
                # width 250
                shape Cylinder
                icon docs/icons/activedirectory.png
            }
            element contributorroletag {
                background LightPink
                color black
                icon docs/icons/gavel.png
            }
            element serviceaccounttag {
                background LightCoral
                shape Person
                icon docs/icons/user-gear.png
            }
            # Azure Styles
            element armtag {
                background SteelBlue
                color White
                shape Robot
                icon docs/icons/gears.png
            }
            # part of Terraform
            element tfstatetag {
                background khaki
                color black
                # height 250
                # width 250
                shape Folder
                icon docs/icons/terraform.png
            }
            element storagetag {
                background PaleGoldenrod
                # color black
                icon docs/icons/storage-box.png
            }
            element osdisktag {
                background cornsilk
                color black
                shape Cylinder
                icon docs/icons/hard-drive.png
            }
            element vmtag {
                background MediumSeaGreen
                color black
                icon docs/icons/vm.png
            }
            element dockertag {
                background PaleGreen
                color black
                icon docs/icons/docker.png
            }
            element piptag {
                background PaleTurquoise
                color black
            }
            element nsgtag {
                background #F08080
                color black
            } 
            element nictag {
                background Cyan
                color black
                icon docs/icons/nic.png
            }   
            element vnettag {
                background PaleTurquoise
                icon docs/icons/network.png
            }
            # Github Styles
            element githubtag {
                background Thistle
                color black
                icon docs/icons/github-mark.png
            }
            element ghactionstag {
                background Plum
                color black
                icon docs/icons/github-mark.png
            }    
            # DNS style
            element dnstag {
                background Gold
                color black
                height 300
                width 250
                shape Cylinder
                icon docs/icons/dns.png
            }
        }
    }
    configuration {
        # scope softwaresystem
    }

}