# Web of Tomorrow Infrastructure Version 0.1.0

The first release of this project is
[version 0.1.0](https://github.com/jkenlooper/weboftomorrow-infrastructure/tree/0.1.0)
and will be used to replace the current infrastructure of this website.
Creating all the CloudFormation templates and other AWS bits continues to be
a learning process. This is a bit challenging at times and has tested my
patience with working with the AWS Console. Most of the time I would get hung
up on permission issues with the different AWS services. Wrapping your head
around how all the users, roles, policies and such work is very helpful when
first getting started in AWS.

There were many iterations when first putting this infrastructure in place. It
started in this website's GitHub project, but then I later decided it would be
best in a separate repo. Then that repo got furter split into another since
I found having different CloudFormation stacks should be used for other
responsibilities.

<figure>
<img class="u-leash" src="/media/weboftomorrow-infrastructure-0.1.0.svg">
<figcaption>Version 0.1.0 layout of infrastructure in AWS</figcaption>
</figure>
