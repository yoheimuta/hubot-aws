# hubot-aws

[![NPM](https://nodei.co/npm/hubot-aws.png)](https://nodei.co/npm/hubot-aws/)

Hubot masters aws commands

## Installation

Add **hubot-aws** to your `package.json` file:

```
npm install --save hubot-aws
```

Add **hubot-aws** to your `external-scripts.json`:

```json
["hubot-aws"]
```

Run `npm install`

## Commands

```ruby
hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] - Create an AutoScaling Group
hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] --dry-run - Try creating an AutoScaling Group
hubot autoscaling delete --group_name=[group_name] - Delete the AutoScaling Group
hubot autoscaling delete --group_name=[group_name] --force - Delete the AutoScaling Group with live instances
hubot autoscaling launch create --name=[launch_configuration_name] - Create an AutoScaling LaunchConfiguration
hubot autoscaling launch create --name=[launch_configuration_name] --dry-run - Try creating an AutoScaling LaunchConfiguration
hubot autoscaling launch delete --name=[launch_configuration_name] - Delete the AutoScaling LaunchConfiguration
hubot autoscaling launch ls - Displays all AutoScaling LaunchConfigurations
hubot autoscaling launch ls --name=[launch_configuration_name] - Details an Autoscaling LaunchConfiguration
hubot autoscaling ls - Displays all AutoScaling Groups
hubot autoscaling ls --name=[group_name] - Details an Autoscaling Group
hubot autoscaling notification delete --group_name=[group_name] --arn=[topic_arn] - Delete the AutoScaling Notificatoin
hubot autoscaling notification ls - Displays all AutoScaling NotificationConfigurations
hubot autoscaling notification ls --group_name=[group_name] - Details an Autoscaling NotificationConfiguration
hubot autoscaling notification put --group_name=[group_name]   - Put an AutoScaling Notifications
hubot autoscaling notification put --group_name=[group_name] --dry-run    - Try putting an AutoScaling Notifications
hubot autoscaling policy delete --group_name=[group_name] --policy_name=[policy_name] - Delete the AutoScaling Policy
hubot autoscaling policy ls - Displays all AutoScaling Policies
hubot autoscaling policy ls --group_name=[group_name] - Details an Autoscaling Policy
hubot autoscaling policy put --add --group_name=[group_name]    - Put an AutoScaling ScaleOut Policy
hubot autoscaling policy put --add --group_name=[group_name] --dry-run    - Try putting an AutoScaling ScaleOut Policy
hubot autoscaling policy put --remove --group_name=[group_name] - Put an AutoScaling ScaleIn Policy
hubot autoscaling policy put --remove --group_name=[group_name] --dry-run - Try putting an AutoScaling ScaleIn Policy
hubot autoscaling update --json=[json] - Update the AutoScaling Group
hubot autoscaling update --name=[name] --desired=[desired] - Update DesiredCapacity the AutoScaling Group
hubot autoscaling update --name=[name] --max=[max] - Update MaxSize of the AutoScaling Group
hubot autoscaling update --name=[name] --min=[min] - Update MinSize of the AutoScaling Group
hubot cloudwatch alarm delete --name=[alarm_name] - Delete the Alarm
hubot cloudwatch alarm ls - Displays all Alarms
hubot cloudwatch alarm ls --name=[alarm_name] - Details an Alarm
hubot ec2 ls - Displays all Instances
hubot ec2 ls --instance_id=[instance_id] - Details an Instance
hubot ec2 run - Run an Instance
hubot ec2 run --dry-run - Try running an Instance
hubot ec2 sg create --vpc_id=[vpc_id] --group_name=[group_name] --desc=[desc] - Create a SecurityGroup
hubot ec2 sg create --vpc_id=[vpc_id] --group_name=[group_name] --desc=[desc] --dry-run - Try creating a SecurityGroup
hubot ec2 sg delete --group_id=[group_id] - Delete the SecurityGroup
hubot ec2 sg ls - Desplays all SecurityGroups
hubot ec2 spot ls - Displays all SpotInstances
hubot ec2 terminate --instance_id=[instance_id] - Terminate the Instance
hubot s3 ls - Displays all S3 buckets
hubot s3 ls --bucket_name=[bucket-name] - Displays all objects
hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] - Displays all objects with prefix
hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] --marker=[marker] - Displays all objects with prefix from marker
```
