# TechTask

## 構成図

- CloudFront + ALB + EC2 + RDS(Aurora) の構成

- CloudFront
  - [AWS for WordPress プラグイン](https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/WordPressPlugIn.html)を導入済み
  - WAF を設定し，開発環境アクセスができるユーザーを絞る
    - 現状は自宅環境からは IPv6 も許可しているが都度 IP アドレスを追加する対応となっている
    - 適用しているルールは次の通り
      - Wordpress application
      - AllowOfficeIP
      - AllowHomeIP
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
  - http 通信を https にリダイレクト設定，Wordpress の HTTP_X_FORWARDED_PROTO 設定，ALB の A レコード登録により，ALB による終端 SSL 化済み
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

### IaC

- 上記構成を terraform にて作成．
- module は[概要](#### module と概要)の通り．
- ただし，次のリソースは import を実施している．
  - CloudFront
    - Wordpress Plugin を使用したため
  - ALB, EC2
    - Console にて作成したため
- GitHub Action による Terraform Deploy 設定済み，ワークフロー実行タイミングは，main ブランチ push, pull request, 手動の 3 パターン.
  - ※下記の通り IaC 化ができていないリソースがあり，今後対応していく．
    - wordpress instance 2 で使用している AMI
    - CloudFront の証明書
    - CloudFront の WAF
    - ALB の証明書
    - ALB の WAF
    - Cloud Watch の Alarm

#### module と概要

    - dns
      - route53 のレコードを追加
    - network
      - vpc, subnet, gateway, route を作成
    - ec2
      - wordpress instance, security group を作成
    - alb
      - alb, target group, security group を作成
    - database
      - aurora cluster, rds instance, parameter group, subnet group, security group を作成
    - iam
      - AWS for WordPress プラグイン実行ユーザーを作成
    - cloudfront
      - CloudFront Distributionを作成
    - webapp
      - Elastic Beanstalk を作成 ※現状使用していない

### 現環境の課題

- 可能な限り，全リソースの IaC 化
- ワークロードのスパイク対応
  - EC2 インスタンスのオートスケール対応
  - or 静的ページのホスティング(S3) + 管理者ページ(Wordpress API)の分離
- 監視設定のチューニング，EC2 以外の監視項目の検討
- CloudFront が TOP ページのみ使用されるため，全ページの CloudFront 経由とする設定見直し
  - 上記の経路が取れた場合，ALB の WAF，セキュリティグループの設定を CloudFront 経由のみを許可するように見直し

## Elastic Beanstalk

- ## PaaS サービス
- [設計上の考慮事項](https://docs.aws.amazon.com/ja_jp/elasticbeanstalk/latest/dg/concepts.concepts.design.html)

  - terraform で頑張ってみたが，Wordpress サイト表示しても 504 エラーとなるのでおそらく通信許可周りがおかしそう． - [terraform 置き場](./terraform) - GitHub Action で Terraform 実行可能

## Lightsail

ALB, Bitnami Wordpress EC2, RDS, DNS Zone をすぐに作成できる
ただしスケールアップ時に停止が必要となるため，イマイチ．
また，terraform はほぼインスタンスのみの対応となっているため自動化するなら CloudFormation 一択．

- 構築メモ

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

お勉強がてら CloudFormation のテンプレートを実行してみた

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
