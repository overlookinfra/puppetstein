## Puppetstein

A standalone tool to automate the building and composition of various versions of puppet-agent components for development and testing.

This is super a work in progress, especially this README.

### Usage

Options:
  `--puppet_agent=<[fork:]SHA>`  The base version of puppet-agent to use. If `fork` is ommitted, `puppetlabs` is used, and builds.puppetlabs.lan will be checked for a corresponding SHA. If `fork` is specified, a new package will be built. Omit this option to use the latest puppet-agent. Conflicts with `--package`.

  `--platform=<OS>` The VMpooler platform to use. Format: platform-version-arch, i.e 'centos-7-x86_64'

  `--build` Option to force puppetstein to build a new puppet-agent package rather than retrieving a pre-existing one. This is set automatically if a fork and branch is specified for the `--puppet-agent` option, or if a Facter version is specified (since we need to rebuild all the C++ in this case).

  `--package=<path/to/package>` Path to a puppet-agent package on the local system to install and use for testing. Conflicts with `--puppet-agent`.

  `--puppet=<fork:SHA>` Fork and SHA of the puppet repo to use in the custom puppet-agent. This option does not build a new package by default.

  `--facter=<fork:SHA>` Fork and SHA of the facter repo to use in the custom puppet-agent. Note that a custom facter will currently require a new puppet-agent build, as it must be compiled.

  `--hiera=<fork:SHA>` Fork and SHA of the hiera repo to use in the custom puppet-agent. This option does not build a new package by default.

  `--agent=<hostname>` Pre-provisioned VMpooler agent to use for testing. Requires --master.

  `--master=<hostname>` Pre-provisioned VMpooler master to use for testing. Requires --agent.

  `--use_last` Option to reuse the same hosts from the last run.

  `--tests=<project:test>` Which project and tests to run against the specified or provisioned systems. Path to tests is relative to the top-level acceptance directory. Example: 'facter:tests/facts/el.rb'

  `--acceptancedir=<path/to/tests>` Path to a local project acceptance dir to use to find tests. If this option is not specified, the appropriate repo (from the `tests` option) will be cloned and tests will be run from there.

  `--keyfile=<path/to/keyfile>` Path to an SSH key to use to authenticate with VMpooler machines.

### Examples and Use Cases

These examples start from the smallest use case of provisioning a FOSS agent-master environment, to running robust test
suites on modified puppet-agent builds (and everything in between).

**1) Install a specific puppet-agent package from builds.puppetlabs.lan on a Centos 7 agent and a RedHat 7 master (default).**

`puppetstein --puppet_agent=puppetlabs:2c3bbe8e6553a533d596cbfe2f86d4ba47c0ec0f --platform=centos-7-x86_64 --keyfile=~/.ssh/id_rsa-acceptance`

**1.5) Do the same as above but use the latest puppet-agent package from nightlies**

`puppetstein --platform=centos-7-x86_64 --keyfile=~/.ssh/id_rsa-acceptance`

This will result in a fully provisioned agent and master with certs signed. The run will conclude with a report indicating
the respective hostnames, which can then be used for further testing.

**2) Using the same puppet-agent SHA as example 1 as a base, modify the install with a puppet feature branch and run a
   specific puppet test on the resulting agent.**

`puppetstein --platform=centos-7-x86_64 --puppet=whopper:my_amazing_branch --tests=puppet:tests/resource/package/yum.rb --keyfile=~/.ssh/id_rsa-acceptance`

**3) Do the same as example 2, but modify the agent with a specific puppet pull request**

`puppetstein --platform=centos-7-x86_64 --puppet=pr_5698 --tests=puppet:tests/resource/package/yum.rb --keyfile=~/.ssh/id_rsa-acceptance`

To use a GitHub pull request, simply specify project:pr_number. Example: `puppet=pr_5698`

To quickly standup a modified agent, this mode will install the base puppet-agent package like before, but patch the
puppet source code with the files from the git branch 'whopper:my_amazing_branch'. Note that currently this branch must
be on GitHub. 

**4) Do the same as #2 but test with a facter test on your local filesystem rather than cloning in the tests**

`puppetstein --platform=centos-7-x86_64 --puppet=whopper:my_amazing_branch --tests=facter:tests/facts/el.rb --acceptancedir=/Users/home/whopper/facter/acceptance --keyfile=~/.ssh/id_rsa-acceptance`

**5) Run a different test on the same hosts that were provisioned in example 3**

`puppetstein --use_last --tests=facter:tests/facts/another_test.rb --keyfile=~/.ssh/id_rsa-acceptance`

**6) Run a test on a preprovisioned agent and master**

`puppetstein --tests=facter:tests/facts/el.rb --agent=nasdqbwbubll --master=nanuduwnuih --keyfile=~/.ssh/id_rsa-acceptance`

**7) Build a new puppet-agent package with modified puppet, facter and hiera code, and then install and test it**

`puppetstein --puppet_agent=puppetlabs:master --platform=debian-8-x86_64 --puppet=whopper:branch1 --facter=branan:factbranch
--hiera=Magisus:hibranch --tests=puppet:tests --build`

To force puppetstein to build a new package, just specify `--build`

**8) Install a pre-existing, local puppet-agent package on new VMpooler VMs and test them**

`puppetstein --platform=debian-8-x86_64 --package=/tmp/puppet-agent.deb --tests=facter:tests/facts/el.rb`
