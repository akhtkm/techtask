# TechTask

---

## 構成図

- ALB + EC2 + RDS(Aurora) の構成
- EC2
  - MultiAZ 構成で作成し，可用性を担保
  - オートスケールを導入していないため，サイズは余裕を持った `t3.medium` を選定
  - [Compute Optimizer](https://console.aws.amazon.com/compute-optimizer/home?region=ap-northeast-1#/dashboard)で今後のサイズを見直ししていく
  - [CloudWatch](https://ap-northeast-1.console.aws.amazon.com/cloudwatch/home?region=ap-northeast-1#alarmsV2:alarm/wordpress-ec2-cpuutilization-alarm?)の cpu 使用率アラームを設定，期待値を超えた場合にメール通知する
    - 手動対応（いずれかの対応を実施）
      - インスタンスを作成済みの AMI(ami-053ac2a39367f8eeb)から追加作成し，ALB のターゲットに追加する．ヘルスチェックが正常であることを確認する．
      - インスタンスを停止し，インスタンスタイプを上位のタイプに変更して起動する．
- RDS(Aurora)
  - サーバレスの自動スケールを利用し，インスタンス課金の抑制を測る
  - MySQL バージョンは 5.6 を採用している．今後，オートスケールに対応させるため，ALB+EC2 の構成を Elastic Beanstalk に置き換えを想定している．Beanstalk のバージョン制約があるため，1 世代前のバージョンとした．
  - 自動バックアップ，メンテナンスを有効化
- ALB
  - MultiAZ 構成で作成，可用性を担保
  - Certificate Manager にて証明書取得済み
  - http通信をhttpsにリダイレクト設定，WordpressのHTTP_X_FORWARDED_PROTO設定，ALBのAレコード登録により，ALBによる終端SSL化済み
- WAF
  - OffceIP の許可ルールを作成し設定．セキュリティグループでもアクセス元制限を実施しているが，オペミス等，事故が無いよう 2 重とした．
  - 他，今回の構成で使用するルールを導入済み
    - Wordpress application
    - AllowOfficeIP
    - AWS-AWSManagedRulesWordPressRuleSet
    - AWS-AWSManagedRulesSQLiRuleSet
    - AWS-AWSManagedRulesPHPRuleSet
    - AWS-AWSManagedRulesLinuxRuleSet
    - AWS-AWSManagedRulesCommonRuleSet
    - AWS-AWSManagedRulesAnonymousIpList
    - AWS-AWSManagedRulesAmazonIpReputationList

![構成図](./system-diagram.drawio.png)

---

## Elastic Beanstalk

- ## PaaS サービス
- [設計上の考慮事項](https://docs.aws.amazon.com/ja_jp/elasticbeanstalk/latest/dg/concepts.concepts.design.html)

  - terraform で頑張ってみたが，Wordpress サイト表示しても 504 エラーとなるのでおそらく通信許可周りがおかしそう． - [terraform 置き場](./terraform) - GitHub Action で Terraform 実行可能

## Lightsail

ALB, Bitnami Wordpress EC2, RDS, DNS Zone をすぐに作成できる
ただしスケールアップ時に停止が必要となるため，イマイチ．
また，terraformはほぼインスタンスのみの対応となっているため自動化するなら CloudFormation 一択．

### 構築メモ

- Lightsail インスタンスを Wordpress イメージで作成
  - セキュリティ設定の通信元を自宅作業用 IP アドレス，オフィスネットのアドレスに変更
- IP アドレスを静的に変更
- Route 53 にカスタムドメインを追加 A レコード
- ロードバランサー作成
- 証明書作成
- Route53 に証明書の名前と値を CNAME として登録
- マルチ AZ でデータベース作成
- Lightsail インスタンスの wordpress 設定の DB 接続情報を作成したデータベースに変更
- Lightsail ディストリビューションを作成
- 証明書を作成
- Route53 に証明書の名前と値を CNAME として登録

## WordPress_Multi_AZ

お勉強がてら CloudFormationのテンプレートを実行してみた

[CloudFormation Template](CloudFormation/WordPress_Multi_AZ/template.yaml)

---

## Best Practice

1. スケーラビリティの確保(reliability)

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
     - EC2 購入方式
     - Trusted Advisor
   - 支出の認識
     - Cloud Watch
     - SNS
   - 継続した最適化
     - AWS 最新情報
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
