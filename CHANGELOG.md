# Changelog

## [v0.6.0](https://github.com/yoheimuta/hubot-aws/tree/v0.6.0) (2021-02-23)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.5.0...v0.6.0)

**Closed issues:**

- How to add instance \<public\_ip\> filed to `ec2 ls` output message? [\#55](https://github.com/yoheimuta/hubot-aws/issues/55)
- Update region environment variable from shell prompt [\#53](https://github.com/yoheimuta/hubot-aws/issues/53)
- Running hubot-aws on AWS Lambda? [\#43](https://github.com/yoheimuta/hubot-aws/issues/43)

**Merged pull requests:**

- Adds scripts to work with IAM users and group [\#58](https://github.com/yoheimuta/hubot-aws/pull/58) ([arifcse019](https://github.com/arifcse019))
- Add ec2 instance ins.PublicIpAddress [\#57](https://github.com/yoheimuta/hubot-aws/pull/57) ([lazysa](https://github.com/lazysa))
- Stopped supporting nodejs 0.12 [\#56](https://github.com/yoheimuta/hubot-aws/pull/56) ([yoheimuta](https://github.com/yoheimuta))
- Typo corrections and README update. [\#51](https://github.com/yoheimuta/hubot-aws/pull/51) ([deep-spaced](https://github.com/deep-spaced))
- solves issue \#34 [\#49](https://github.com/yoheimuta/hubot-aws/pull/49) ([toadkicker](https://github.com/toadkicker))
- implement \#36 [\#48](https://github.com/yoheimuta/hubot-aws/pull/48) ([toadkicker](https://github.com/toadkicker))

## [v0.5.0](https://github.com/yoheimuta/hubot-aws/tree/v0.5.0) (2016-08-19)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.4.0...v0.5.0)

**Merged pull requests:**

- Issue \#39 - Add SNS Support [\#47](https://github.com/yoheimuta/hubot-aws/pull/47) ([toadkicker](https://github.com/toadkicker))
- Upgrade moment to 2.13.0 [\#45](https://github.com/yoheimuta/hubot-aws/pull/45) ([waniji](https://github.com/waniji))

## [v0.4.0](https://github.com/yoheimuta/hubot-aws/tree/v0.4.0) (2016-06-27)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.3.1...v0.4.0)

**Merged pull requests:**

- Added command of autoscaling scheduled action \[ls|put|delete\] [\#46](https://github.com/yoheimuta/hubot-aws/pull/46) ([waniji](https://github.com/waniji))

## [v0.3.1](https://github.com/yoheimuta/hubot-aws/tree/v0.3.1) (2016-06-23)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.3.0...v0.3.1)

**Merged pull requests:**

- Upgrade aws-sdk-js to the latest version [\#44](https://github.com/yoheimuta/hubot-aws/pull/44) ([waniji](https://github.com/waniji))

## [v0.3.0](https://github.com/yoheimuta/hubot-aws/tree/v0.3.0) (2016-01-07)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.2.0...v0.3.0)

**Merged pull requests:**

- ec2 ls: allow filtering instances by name [\#41](https://github.com/yoheimuta/hubot-aws/pull/41) ([relvao](https://github.com/relvao))

## [v0.2.0](https://github.com/yoheimuta/hubot-aws/tree/v0.2.0) (2015-10-11)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.1.0...v0.2.0)

**Implemented enhancements:**

- Enable to create tags when hubot ec2 run [\#28](https://github.com/yoheimuta/hubot-aws/issues/28)
- Add commands to control EC2 tags [\#27](https://github.com/yoheimuta/hubot-aws/issues/27)
- Enable to pass a config file path [\#26](https://github.com/yoheimuta/hubot-aws/issues/26)
- Support json as well as cson [\#25](https://github.com/yoheimuta/hubot-aws/issues/25)

**Closed issues:**

- Make easy to read help and README [\#29](https://github.com/yoheimuta/hubot-aws/issues/29)

**Merged pull requests:**

- Added command of ec2 tag \[ls|create|delete\] [\#33](https://github.com/yoheimuta/hubot-aws/pull/33) ([yoheimuta](https://github.com/yoheimuta))
- Added example json files [\#32](https://github.com/yoheimuta/hubot-aws/pull/32) ([yoheimuta](https://github.com/yoheimuta))
- Make easy to read full spec in each file and README [\#31](https://github.com/yoheimuta/hubot-aws/pull/31) ([yoheimuta](https://github.com/yoheimuta))
- Enabled to pass configpath arg/26 [\#30](https://github.com/yoheimuta/hubot-aws/pull/30) ([yoheimuta](https://github.com/yoheimuta))

## [v0.1.0](https://github.com/yoheimuta/hubot-aws/tree/v0.1.0) (2015-10-09)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.0.5...v0.1.0)

**Implemented enhancements:**

- Describe and delete images \(AMI\) [\#20](https://github.com/yoheimuta/hubot-aws/issues/20)
- Added tests and CI [\#19](https://github.com/yoheimuta/hubot-aws/issues/19)
- Fixed function name of get\_arg\_params from snake case to camel case [\#16](https://github.com/yoheimuta/hubot-aws/issues/16)
- Fixed the command match logic to more flexible [\#1](https://github.com/yoheimuta/hubot-aws/issues/1)

**Fixed bugs:**

- typo: hubot ec2 run --image-id=\[ami-id\] [\#17](https://github.com/yoheimuta/hubot-aws/issues/17)

**Merged pull requests:**

- \(refs \#1\)Changed how to capture arg params [\#24](https://github.com/yoheimuta/hubot-aws/pull/24) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#20\)Support ami api to create, deregister and ls [\#23](https://github.com/yoheimuta/hubot-aws/pull/23) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#16\)Fixed sneak case function names [\#22](https://github.com/yoheimuta/hubot-aws/pull/22) ([yoheimuta](https://github.com/yoheimuta))
- Introduced grunt/19 [\#21](https://github.com/yoheimuta/hubot-aws/pull/21) ([yoheimuta](https://github.com/yoheimuta))

## [v0.0.5](https://github.com/yoheimuta/hubot-aws/tree/v0.0.5) (2015-07-01)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.0.4...v0.0.5)

**Merged pull requests:**

- \(refs \#17\)Replaced image-id with image\_id [\#18](https://github.com/yoheimuta/hubot-aws/pull/18) ([yoheimuta](https://github.com/yoheimuta))

## [v0.0.4](https://github.com/yoheimuta/hubot-aws/tree/v0.0.4) (2015-05-06)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.0.3...v0.0.4)

**Implemented enhancements:**

- Set maxsize of autoscaling when autoscaling create with capacity [\#9](https://github.com/yoheimuta/hubot-aws/issues/9)
- Prepared example cson files to run ec2 and autoscaling [\#7](https://github.com/yoheimuta/hubot-aws/issues/7)
- Enabled to give an ami-id as an argument to commands of `ec2 run` and `autoscaling launch create` [\#6](https://github.com/yoheimuta/hubot-aws/issues/6)
- Handled error of not found the resource like \*.cson [\#3](https://github.com/yoheimuta/hubot-aws/issues/3)

**Fixed bugs:**

- Bug: a command of autoscaling notification put invokes a wrong AWS API [\#8](https://github.com/yoheimuta/hubot-aws/issues/8)
- Fixed to output a wrong name of the instance that has no name in a command of ec2 ls [\#5](https://github.com/yoheimuta/hubot-aws/issues/5)

**Merged pull requests:**

- \(refs \#6\)Overrode image-id\(=ami-id\) of cson by a given one [\#15](https://github.com/yoheimuta/hubot-aws/pull/15) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#7\)Prepared example files of env and cson to show reference settings [\#14](https://github.com/yoheimuta/hubot-aws/pull/14) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#3\)Checked error of not found about a cson file [\#13](https://github.com/yoheimuta/hubot-aws/pull/13) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#5\)Set \[NoName\] as default ec2 name if the name is empty [\#12](https://github.com/yoheimuta/hubot-aws/pull/12) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#9\)Set maxsize of autoscaling group to avoid scale out when an argument of capacity is not empty [\#11](https://github.com/yoheimuta/hubot-aws/pull/11) ([yoheimuta](https://github.com/yoheimuta))
- \(refs \#8\)Fixed to invoke right apis about autoscaling notification [\#10](https://github.com/yoheimuta/hubot-aws/pull/10) ([yoheimuta](https://github.com/yoheimuta))

## [v0.0.3](https://github.com/yoheimuta/hubot-aws/tree/v0.0.3) (2015-04-28)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.0.2...v0.0.3)

**Implemented enhancements:**

- Created an autoscaling group with an argument of desiredCapacity [\#2](https://github.com/yoheimuta/hubot-aws/issues/2)

## [v0.0.2](https://github.com/yoheimuta/hubot-aws/tree/v0.0.2) (2015-04-28)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/v0.0.1...v0.0.2)

**Merged pull requests:**

- Created autoscaling group with desired capacity/2 [\#4](https://github.com/yoheimuta/hubot-aws/pull/4) ([yoheimuta](https://github.com/yoheimuta))

## [v0.0.1](https://github.com/yoheimuta/hubot-aws/tree/v0.0.1) (2015-04-22)

[Full Changelog](https://github.com/yoheimuta/hubot-aws/compare/20b7dc6349519171e0360a70a7e2794281a764a8...v0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
