# TechTask

1. スケーラビリティの確保

- EC2 Auto Recovery
- EC2 Auto Scailing
- Cloud Watch
- RDS
- DynamoDB

1. 環境の自動化

- Cloud Formation
- Code シリーズ
- ECS
- Elastic Beanstalk
- OpeWorks
- Cloud Watch

1. 使い捨てリソースの使用

- EC2
- Auto Scaling

1. コンポーネントの疎結合

- ELB
- SNS
- SQS

1. サーバーではなくサービス（サーバレス）

- Lamda
- SNS
- SQS
- ELB
- SES
- DynamoDB
- Amazon API Gateway
- Amazon Cognite

1. 最適なデータベース選択

- RedShift
- RDS
- DynamoDB
- Aurora
- Elasticsearch

1. 増大するデータ量対応

- S3
- Kinesis
- Glacier

1. 単一障害点の排除

- アーキテクチャで高可用性を実現すべきサービス
    - EC2
    - Direct Connect
- 利用する主要サービス
    - ELB

1. コスト最適化

- 需要と供給の一致
    - Auto Scaling
- コスト効率の高いリソース
    - EC2購入方式
    - Trusted Advisor
- 支出の認識
    - Cloud Watch
    - SNS
- 継続した最適化
    - AWS最新情報
    - Trusted Advisor

1. キャッシュの利用

- CloudFront
- ElastiCache

1. セキュリティの確保

- データ保護
    - ELB
    - EBS
    - S3
    - RDS
    - KMS
- 権限管理
    - IAM
    - MFA
- インフラ保護
    - VPC
- 検出制御
    - Cloud Trail
    - AWS Config
    - Cloud Watch

## WordPress_Multi_AZ

CloudFormation Template

## Lightsail

Bitnami Wordpressインスタンスをすぐに作成できる
ただしスケールアップ時に停止が必要

### 構築メモ

- LightsailインスタンスをWordpressイメージで作成
- IPアドレスを静的に変更
- Route 53にカスタムドメインを追加 Aレコード
- ロードバランサー作成
- 証明書作成
- Route53に証明書の名前と値をCNAMEとして登録
- マルチAZでデータベース作成
- Lightsailインスタンスのwordpress設定のDB接続情報を作成したデータベースに変更
- Lightsailディストリビューションを作成
- 証明書を作成
- Route53に証明書の名前と値をCNAMEとして登録
- 