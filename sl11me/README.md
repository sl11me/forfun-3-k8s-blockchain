🚀 Infrastructure 3-Tier avec Terraform

Petit projet de mise en place d’une architecture 3-tier AWS, automatisée avec Terraform.
L’objectif: Compétences en infrastructure-as-code (IaC) et en gestion d’architectures cloud scalables et sécurisées.

📸 Architecture
L’infrastructure est composée de :

Tier Web (Public) : Instances EC2 derrière un Application Load Balancer avec Auto Scaling.
Tier Application (Privé) : Instances EC2 dédiées au traitement des requêtes et communication avec la base de données.
Tier Base de Données (Privé) : Deux instances MySQL (Azure Database for MySQL Server) réparties sur différentes zones de disponibilité pour la haute disponibilité.

🛠️ Technologies utilisées
Terraform : Provisionnement de l’infrastructure.
AWS : VPC, Subnets,Security-Groups EC2, ALB, Auto Scaling
Base de données MYSQL relationnelle gérée.
