require_relative 'util/log_utils.rb'

module Puppetstein
  # map beaker-hostgenerator names to vanagon targets
  HOST_MAP = {
    # 'aix53-POWER'  => 'aix-5.3-ppc',
    # 'aix61-POWER'  => 'aix-6.1-ppc',
    # 'aix71-POWER'  => 'aix-7.1-ppc',
    # 'aix72-POWER'  => 'aix-7.1-ppc',
    'arista4-32'          => 'eos-4-i386',
    'centos5-32'          => 'el-5-i386',
    'centos5-64'          => 'el-5-x86_64',
    'centos6-32'          => 'el-6-i386',
    'centos6-64'          => 'el-6-x86_64',
    'centos7-64'          => 'el-7-x86_64',
    'cisconx-64'          => 'cisco-wrlinux-5-x86_64',
    'cumulus25-64'        => 'cumulus-2.2.-amd64',
    'debian7-32'          => 'debian-7-i386',
    'debian7-64'          => 'debian-7-amd64',
    'debian8-32'          => 'debian-8-i386',
    'debian8-64'          => 'debian-8-amd64',
    'fedora24-32'         => 'fedora-f24-i386',
    'fedora24-64'         => 'fedora-f24-x86_64',
    'fedora25-32'         => 'fedora-f25-i386',
    'fedora25-64'         => 'fedora-f25-x86_64',
    'osx1010-64'          => 'osx-10.10-x86_64',
    'osx1011-64'          => 'osx-10.11-x86_64',
    'osx1012-64'          => 'osx-10.12-x86_64',
    'redhat5-32'          => 'el-5-i386',
    'redhat5-64'          => 'el-5-x86_64',
    'redhat6-32'          => 'el-6-i386',
    'redhat6-64'          => 'el-6-x86_64',
    'redhat7-32'          => 'el-7-i386',
    'redhat7-64'          => 'el-7-x86_64',
    'sles11-32'           => 'sles-11-i386',
    'sles11-64'           => 'sles-11-x86_64',
    'sles12-64'           => 'sles-12-x86_64',
    'sles11-S390X'        => 'sles-11-s390x',
    'sles12-S390X'        => 'sles-12-s390x',
    'solaris10-32'        => 'solaris-10-i386',
    'solaris10-64'        => 'solaris-10-i386',
    'solaris11-32'        => 'solaris-11-i386',
    'solaris11-64'        => 'solaris-11-i386',
    'ubuntu1404-32'       => 'ubuntu-14.04-i386',
    'ubuntu1404-64'       => 'ubuntu-14.04-x86_64',
    'ubuntu1604-32'       => 'ubuntu-16.04-i386',
    'ubuntu1604-64'       => 'ubuntu-16.04-amd64',
    'ubuntu1610-32'       => 'ubuntu-16.10-i386',
    'ubuntu1610-64'       => 'ubuntu-16.10-amd64',
    'windows2008r2-64'    => 'windows-2012r2-x64',
    'windows2012r2-64'    => 'windows-2012r2-x64',
    'windows2012r2_ja-64' => 'windows-2012r2-x64',
    'windows2016-64'      => 'windows-2012r2-x64',
    'windows10ent-32'     => 'windows-2012r2-x86',
    'windows10ent-64'     => 'windows-2012r2-x64',
  }

  def validate_platform(platform_string)
    if HOST_MAP[platform_string]
      return platform_string
    end

    # invalid platform
    log_error "#{platform_string} not a valid platform. Please use one of #{HOST_MAP.keys}"
    exit(1)
  end
end
