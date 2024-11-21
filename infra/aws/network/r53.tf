# resource "aws_route53_zone" "env" {
#   name = "${var.env_name}.${var.dns_parent}"
# }

# resource "aws_route53_zone" "client" {
#   name = "${var.env_name}.${var.clientdns_parent}"
# }

# # DNS record for platform pointing to the ALB
# resource "aws_route53_record" "app" {
#   zone_id = aws_route53_zone.env.zone_id
#   name    = "${var.infra_name}-lb.${aws_route53_zone.env.name}"
#   type    = "A"
#   alias {
#     name                   = aws_lb.default.dns_name
#     zone_id                = aws_lb.default.zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "cert_validation" {
#   allow_overwrite = true
#   name     = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_name
#   records  = [ tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_value ]
#   type     = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_type
#   zone_id  = aws_route53_zone.env.id
#   ttl      = 60
# }