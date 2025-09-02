terraform {
  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "~>2.6.0"
    }
  }
}

provider "maas" {
  api_version = "2.0"
  api_url     = "http://maas.cluster.gohfert.com:5240/MAAS"
  # API key read from env var `MAAS_API_KEY`
}
