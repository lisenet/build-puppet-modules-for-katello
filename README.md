# build-puppet-modules-for-katello
Script to build local Puppet modules which can then be imported in to Katello. No need for Git repository or Puppet Forge.
# Katello Repository
A Katello repository may be a plain directory containing a Pulp manifest and packaged Puppet modules. According to the Pulp project documentation, the Pulp manifest is a file listing each Puppet module contained in the directory. Each module is listed on a separate line which has the following format: <strong>name,checksum,size</strong>.

The <strong>name</strong> is the file name, the  <strong>checksum</strong> is SHA256 digest of the file, and the <strong>size</strong> is the size of the file in bytes. The Pulp manifest must be named <strong>PULP_MANIFEST</strong>.

Having this knowledge, we can build Puppet modules manually, generate a Pulp manifest and import everything in to Katello.
# Katello Separate Lifecycle for Puppet Modules
https://www.lisenet.com/2018/katello-separate-lifecycle-for-puppet-modules/
