data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  az_count     = length(local.selected_azs)

  public_subnet_cidrs = var.public_subnet_cidrs != null && length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : [
    for idx in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, idx)
  ]

  app_subnet_cidrs = var.app_subnet_cidrs != null && length(var.app_subnet_cidrs) > 0 ? var.app_subnet_cidrs : [
    for idx in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, idx + local.az_count)
  ]

  db_subnet_cidrs = var.db_subnet_cidrs != null && length(var.db_subnet_cidrs) > 0 ? var.db_subnet_cidrs : [
    for idx in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, idx + (local.az_count * 2))
  ]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-igw"
  })
}

resource "aws_subnet" "public" {
  count = local.az_count

  vpc_id                  = aws_vpc.this.id
  availability_zone       = local.selected_azs[count.index]
  cidr_block              = local.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-public-${local.selected_azs[count.index]}"
    Tier = "public"
  })
}

resource "aws_subnet" "app" {
  count = local.az_count

  vpc_id            = aws_vpc.this.id
  availability_zone = local.selected_azs[count.index]
  cidr_block        = local.app_subnet_cidrs[count.index]

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-app-${local.selected_azs[count.index]}"
    Tier = "application"
  })
}

resource "aws_subnet" "db" {
  count = local.az_count

  vpc_id            = aws_vpc.this.id
  availability_zone = local.selected_azs[count.index]
  cidr_block        = local.db_subnet_cidrs[count.index]

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-db-${local.selected_azs[count.index]}"
    Tier = "database"
  })
}

resource "aws_eip" "nat" {
  vpc = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-nat"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = local.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-app-rt"
  })
}

resource "aws_route_table_association" "app" {
  count = local.az_count

  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-db-rt"
  })
}

resource "aws_route_table_association" "db" {
  count = local.az_count

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}
