# hubot-aws  [![npm version](https://badge.fury.io/js/hubot-aws.svg)](http://badge.fury.io/js/hubot-aws) [![Build Status](https://travis-ci.org/yoheimuta/hubot-aws.svg?branch=master)](https://travis-ci.org/yoheimuta/hubot-aws) [![Dependency Status](https://david-dm.org/yoheimuta/hubot-aws.svg)](https://david-dm.org/yoheimuta/hubot-aws)

Hubot masters aws commands

I wrote a guest blog published by PacktPub about a quick intro to this npm module.
See https://www.packtpub.com/books/content/part2-chatops-slack-and-aws-cli.

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

## Auth

Access Control with [hubot-auth](https://github.com/hubot-scripts/hubot-auth).

- User with `admin` or the role defined `HUBOT_AWS_CAN_ACCESS_ROLE` can run all commands.

```ruby
# against user without a valid role
hubot> hubot ec2 run
You cannot access this feature. Please contact with admin
```

- You can disable access control like below.

```ruby
export HUBOT_AWS_DEBUG="1"
```

## Commands

See [scripts/**.coffee](https://github.com/yoheimuta/hubot-aws/tree/master/scripts) for full documentation.

```ruby
hubot autoscaling create - Create an AutoScaling Group
hubot autoscaling delete --group_name=[group_name] - Delete the AutoScaling Group
hubot autoscaling delete --group_name=[group_name] --force - Delete the AutoScaling Group with live instances
hubot autoscaling launch create - Create an AutoScaling LaunchConfiguration
hubot autoscaling launch delete --name=[launch_configuration_name] - Delete the AutoScaling LaunchConfiguration
hubot autoscaling launch ls - Displays all AutoScaling LaunchConfigurations
hubot autoscaling launch ls --name=[launch_configuration_name] - Details an Autoscaling LaunchConfiguration
hubot autoscaling ls - Displays all AutoScaling Groups
hubot autoscaling ls --name=[group_name] - Details an Autoscaling Group
hubot autoscaling notification delete --group_name=[group_name] --arn=[topic_arn] - Delete the AutoScaling Notificatoin
hubot autoscaling notification ls - Displays all AutoScaling NotificationConfigurations
hubot autoscaling notification ls --group_name=[group_name] - Details an Autoscaling NotificationConfiguration
hubot autoscaling notification put - Put an AutoScaling Notifications
hubot autoscaling policy delete --policy_name=[policy_name] - Delete the AutoScaling Policy
hubot autoscaling policy ls - Displays all AutoScaling Policies
hubot autoscaling policy ls --group_name=[group_name] - Details an Autoscaling Policy
hubot autoscaling policy put --add - Put an AutoScaling ScaleOut Policy
hubot autoscaling policy put --remove - Put an AutoScaling ScaleIn Policy
hubot autoscaling update --json=[json] - Update the AutoScaling Group
hubot autoscaling update --json=[json] --dry-run - Try updating the AutoScaling Group
hubot autoscaling update --name=[name] --desired=[desired] - Update DesiredCapacity the AutoScaling Group
hubot autoscaling update --name=[name] --desired=[desired] --dry-run - Try updating DesiredCapacity the AutoScaling Group
hubot autoscaling update --name=[name] --max=[max] - Update MaxSize of the AutoScaling Group
hubot autoscaling update --name=[name] --max=[max] --dry-run - Try updating MaxSize of the AutoScaling Group
hubot autoscaling update --name=[name] --min=[min] - Update MinSize of the AutoScaling Group
hubot autoscaling update --name=[name] --min=[min] --dry-run - Try updating MinSize of the AutoScaling Group
hubot cloudwatch alarm delete --name=[alarm_name] - Delete the Alarm
hubot cloudwatch alarm ls - Displays all Alarms
hubot cloudwatch alarm ls --name=[alarm_name] - Details an Alarm
hubot ec2 ami create --instance_id=*** - Create an ami.
hubot ec2 ami deregister --ami_id=[ami_id] - Deregisters the specified AMI
hubot ec2 ami ls - Desplays all AMI(Images)
hubot ec2 ls - Displays all Instances
hubot ec2 ls --instance_id=[instance_id] - Details an Instance
hubot ec2 ls --instance_filter=[instance_name] - Instances that contain instance_name in name
hubot ec2 run - Run an Instance
hubot ec2 sg create --group_name=[group_name] --desc=[desc] --vpc_id=[vpc_id] - Create a SecurityGroup
hubot ec2 sg delete --group_id=[group_id] - Delete the SecurityGroup
hubot ec2 sg ls - Desplays all SecurityGroups
hubot ec2 spot ls - Displays all SpotInstances
hubot ec2 tag create --resource_id=*** --tag_key=*** --tag_value=*** - Create a tag.
hubot ec2 tag delete --resource_id=*** - Deletes the specified set of tags
hubot ec2 tag ls - Desplays all tags
hubot ec2 terminate --instance_id=[instance_id] - Terminate the Instance
hubot s3 ls - Displays all S3 buckets
hubot s3 ls --bucket_name=[bucket-name] - Displays all objects
hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] - Displays all objects with prefix
hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] --marker=[marker] - Displays all objects with prefix from marker
```

## Configurations

Set environment variables like an example below.

```ruby
# required
export HUBOT_AWS_ACCESS_KEY_ID="ACCESS_KEY"
export HUBOT_AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY"
export HUBOT_AWS_REGION="ap-northeast-1"
# required when used
export HUBOT_AWS_DEBUG="1"
export HUBOT_AWS_CAN_ACCESS_ROLE="tech"
## allow json and cson fileformat as each api config
export HUBOT_AWS_EC2_RUN_CONFIG="files/aws/ec2/run/app.json"
export HUBOT_AWS_EC2_RUN_USERDATA_PATH="files/aws/ec2/run/initfile"
export HUBOT_AWS_EC2_CREATE_AMI_CONFIG="files/aws/ec2/create_ami/app.cson"
export HUBOT_AWS_AS_LAUNCH_CONF_CONFIG="files/aws/autoscaling/create_launch_configuration/app.cson"
export HUBOT_AWS_AS_LAUNCH_CONF_USERDATA_PATH="files/aws/autoscaling/create_launch_configuration/initfile"
export HUBOT_AWS_AS_GROUP_CONFIG="files/aws/autoscaling/create_group/app.cson"
export HUBOT_AWS_AS_POLICY_ADD="files/aws/autoscaling/put_policy/add/app.cson"
export HUBOT_AWS_AS_POLICY_REMOVE="files/aws/autoscaling/put_policy/remove/app.cson"
export HUBOT_AWS_AS_NOTIFICATION="files/aws/autoscaling/put_notification/app.cson"
export HUBOT_AWS_CW_ALARM_ADD="files/aws/cloudwatch/put_metric_alarm/add/app.cson"
export HUBOT_AWS_CW_ALARM_REMOVE="files/aws/cloudwatch/put_metric_alarm/remove/app.cson"
```

You can build your own configurations by referring to the [example files](https://github.com/yoheimuta/hubot-aws/tree/master/example).

## Examples

### EC2

hubot ec2 ls - Displays all Instances

```ruby
hubot> hubot ec2 ls
Fetching ...
hubot> time     state   id      image   az      subnet  type    ip      name
2015-04-17 17:02:27+09:00       running i-25588ed0      ami-AAA    ap-northeast-1c subnet-AAA t2.micro        10.0.2.125      app-autoscaling-ondemand
2015-04-17 17:05:40+09:00       running i-f6469003      ami-BBB    ap-northeast-1c subnet-BBB t2.micro        10.0.2.146      app-autoscaling
```

hubot ec2 run - Run an Instance

```ruby
hubot> hubot ec2 run
Requesting dry-run=false...
hubot> pending  i-e23ce817      t2.micro       172.31.19.69    undefined
```

hubot ec2 terminate --instance_id=[instance_id] - Terminate the Instance

```ruby
hubot> hubot ec2 terminate --instance_id=i-e23ce817
Terminating i-e23ce817...
hubot> i-e23ce817    shutting-down
```

### AutoScaling

hubot autoscaling launch ls - Displays all AutoScaling LaunchConfigurations

```ruby
hubot> hubot autoscaling launch ls
Fetching ...
hubot> time     name    image   type    price   security
2015-04-17 15:31:17+09:00       app-20150417     ami-AAA    c3.xlarge       1.000   sg-AAA
2015-04-17 16:07:29+09:00       app-20150417-ondemand    ami-BBB    c3.xlarge       [NoPrice]       sg-BBB
```

hubot autoscaling launch create --name=[launch_configuration_name] - Create an AutoScaling LaunchConfiguration

```ruby
hubot> hubot autoscaling launch create --name=app-20150417
Requesting app...
hubot> { ResponseMetadata: { RequestId: '68e4734f-e4d0-11e4-8995-AAA' } }
```

hubot autoscaling ls - Displays all AutoScaling Groups

```ruby
hubot> hubot autoscaling ls
Fetching ...
hubot> time     current_size    desired_size    min_size        max_size        az      elb     conf    name
        tag.Key tag.Value
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
2015-04-17 15:42:00+09:00       5      5      1       1000      ap-northeast-1a app-elb  app-20150417     app-group-20150417
        Name    app-autoscaling
        role    app
2015-04-17 16:10:02+09:00       2       2       1       500      ap-northeast-1a app-elb  app-20150417-ondemand    app-group-20150417-ondemand
        Name    app-autoscaling-ondemand
        role    app
```

hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] - Create an AutoScaling Group

```ruby
hubot> hubot autoscaling create --name=app-group-20150417 --launch_name=app-20150417
Requesting name=app-group-20150417, conf=app-20150417...
hubot> { ResponseMetadata: { RequestId: 'd9f1a0ee-e4cc-11e4-9d11-AAA' } }
```

hubot autoscaling update --name=[name] --desired=[desired] - Update DesiredCapacity the AutoScaling Group

```ruby
hubot> hubot autoscaling update --name=app-group-20150417 --desired=9
Requesting AutoScalingGroupName=app-group-20150417, DesiredCapacity=9...
hubot> { ResponseMetadata: { RequestId: '590e22f0-e4cb-11e4-a03d-AAA' } }
```

hubot autoscaling policy ls - Displays all AutoScaling Policies

```ruby
hubot> hubot autoscaling policy ls
Fetching ...
hubot> name     type    adjustment      cooldown        group_name
        time    namespace       metric  statistic       threshold       period  operator        alarm_name
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

Add     ChangeInCapacity        2       300     app-group-20150417
        2015-04-23 21:50:46+09:00       AWS/EC2 CPUUtilization  Average 45      900     GreaterThanOrEqualToThreshold   awsec2-app-group-20150417-CPU-Utilization

Remove  ChangeInCapacity        -1      [NoValue]       app-group-20150417
        2015-04-23 21:50:47+09:00       AWS/EC2 CPUUtilization  Average 30      900     LessThanOrEqualToThreshold      awsec2-app-group-20150417-High-CPU-Utilization
```

hubot autoscaling policy put --add --group_name=[group_name]    - Put an AutoScaling ScaleOut Policy

```ruby
hubot> hubot autoscaling policy put --add --group_name=app-group-20150417
Requesting add policy, AutoScalingGroupName=app-group-20150417, dry-run=false...
hubot> { ResponseMetadata: { RequestId: 'c7c33a7b-e822-11e4-bd7f-AAA' },
      PolicyARN: 'arn:aws:autoscaling:ap-northeast-1:AAA:scalingPolicy:e8f4b6cb-9d86-4b89-b475-AAA:autoScalingGroupName/app-group-20150417:policyName/Add' }
{ ResponseMetadata: { RequestId: 'c88c7e44-e822-11e4-b90d-AAA' } }
```

hubot autoscaling policy put --remove --group_name=[group_name] - Put an AutoScaling ScaleIn Policy

```ruby
hubot> hubot autoscaling policy put --remove --group_name=app-group-20150417
Requesting remove policy, AutoScalingGroupName=app-group-20150417, dry-run=false...
hubot> { ResponseMetadata: { RequestId: '14992ecb-e823-11e4-9c53-b9547125f053' },
      PolicyARN: 'arn:aws:autoscaling:ap-northeast-1:199839016800:scalingPolicy:86f364a3-b495-4d86-a17b-ad539177f021:autoScalingGroupName/app-group-20150417:policyName/Remove' }
```

hubot autoscaling notification ls - Displays all AutoScaling NotificationConfigurations

```ruby
hubot> hubot autoscaling notification ls
Fetching ...
hubot> name     type    topic_arn
app-group-20150417       autoscaling:EC2_INSTANCE_LAUNCH arn:aws:sns:ap-northeast-1:AAA:autoscaling-notice
app-group-20150417       autoscaling:EC2_INSTANCE_TERMINATE      arn:aws:sns:ap-northeast-1:AAA:autoscaling-notice
app-group-20150417       autoscaling:EC2_INSTANCE_TERMINATE_ERROR        arn:aws:sns:ap-northeast-1:AAA:autoscaling-notice
app-group-20150417       autoscaling:EC2_INSTANCE_LAUNCH_ERROR   arn:aws:sns:ap-northeast-1:AAA:autoscaling-notice
```

hubot autoscaling notification put --group_name=[group_name]   - Put an AutoScaling Notifications

```ruby
hubot> hubot autoscaling notification put --group_name=app-group-20150417
Requesting notifications, AutoScalingGroupName=app-group-20150417, dry-run=false...
hubot> { ResponseMetadata: { RequestId: '9b764201-e4cb-11e4-bb52-AAA' } }
```

### Cloudwatch

hubot cloudwatch alarm ls - Displays all Alarms

```ruby
hubot> hubot cloudwatch alarm ls
Fetching ...
hubot> time    namespace    metric    statistic    threshold    period    operator    name
dimension.Name    dimension.Value
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

2014-12-12 14:05:49+09:00    AWS/EC2    CPUUtilization    Average    30    3600    LessThanOrEqualToThreshold    awsec2-app-group-20141209-High-CPU-Utilization
    AutoScalingGroupName    app-group-20141209

2014-12-19 12:15:07+09:00    AWS/EC2    CPUUtilization    Average    30    21600    LessThanOrEqualToThreshold    awsec2-app-autoscaling-20141219-High-CPU-Utilization
    AutoScalingGroupName    app-autoscaling-20141219
```

### S3

hubot s3 ls - Displays all S3 buckets

```ruby
hubot> hubot s3 ls
Fetching ...
hubot> time    name
2014-08-05 14:59:21+09:00    app
2014-08-05 17:39:45+09:00    app-images
```

hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] - Displays all objects with prefix

```ruby
hubot> hubot s3 ls --bucket_name=app-images --prefix=images/
Fetching app-images, images/, ...
hubot> Prefix
images/000e90ea2e01b830a8d6cd68a10b3e5becdd8a98e41b402a9da3ad97eda1332e/
images/001c03788ee31167872d38ce09493a4deb1cbe11728a762065ee1a5acfd1404b/
...
```

## Recommended Usage

### Use `--dry-run`

```ruby
hubot> hubot ec2 run --dry-run
Requesting dry-run=true...
{ MinCount: 1,
  MaxCount: 1,
  DryRun: false,
  ImageId: 'ami-AAA',
  KeyName: 'aws',
  InstanceType: 't2.micro',
  Placement: { AvailabilityZone: 'ap-northeast-1a' },
  NetworkInterfaces:
   [ { Groups: [ 'sg-AAA' ],
       SubnetId: 'subnet-AAA',
       DeviceIndex: 0,
       AssociatePublicIpAddress: true } ],
  UserData: 'IyEvYmluL2Jhc2gKCiMgc2V0dXAgc3RhcnQgbm90aWZ5CkhPU1RfTkFNRT1gaG9zdG5hbWVgCg...

# Then, remove --dry-run option
hubot> hubot ec2 run
...
```

### Use [hubot-env](https://github.com/yoheimuta/hubot-env)

You can switch environment variables about AWS Account Credentials via hubot command dynamically, if you want to manage multi accounts.

```ruby
# Load new environment variables abount AWS credentials of account 1.
hubot> hubot env load --filename=aws-cred-account1.env
Loading env --filename=aws-cred-account1.env, --dry-run=false...
HUBOT_AWS_CREDENTIALS=account1
HUBOT_AWS_ACCESS_KEY_ID=ACCESS_KEY1
HUBOT_AWS_SECRET_ACCESS_KEY=***
HUBOT_AWS_REGION=ap-northeast-1

# Then, Switch to overwrite environment variables abount AWS credentials of account 2.
hubot> hubot env load --filename=aws-cred-account2.env
Loading env --filename=aws-cred-account2.env, --dry-run=false...
HUBOT_AWS_CREDENTIALS=account2
HUBOT_AWS_ACCESS_KEY_ID=ACCESS_KEY2
HUBOT_AWS_SECRET_ACCESS_KEY=***
HUBOT_AWS_REGION=ap-northeast-1
```

### Use [hubot-hint](https://github.com/yoheimuta/hubot-hint)

`hubot-aws`supports many commands and some commands require multi arguments.
`hubot-hint` shows rest of command help.

```ruby
# Search commandHelps with `autoscaling launch`
hubot> hubot autoscaling launch hint
hubot>
hubot autoscaling launch create --name=[launch_configuration_name] - Create an AutoScaling LaunchConfiguration
hubot autoscaling launch create --name=[launch_configuration_name] --dry-run - Try creating an AutoScaling LaunchConfiguration
hubot autoscaling launch delete --name=[launch_configuration_name] - Delete the AutoScaling LaunchConfiguration
hubot autoscaling launch ls - Displays all AutoScaling LaunchConfigurations
hubot autoscaling launch ls --name=[launch_configuration_name] - Details an Autoscaling LaunchConfiguration

# Search commandHelps with `autoscaling launch create`
hubot> hubot autoscaling launch create hint
hubot>
hubot autoscaling launch create --name=[launch_configuration_name] - Create an AutoScaling LaunchConfiguration
hubot autoscaling launch create --name=[launch_configuration_name] --dry-run - Try creating an AutoScaling LaunchConfiguration
```
