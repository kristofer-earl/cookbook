couchbase Cookbook
==================
This cookbook installs basic installation of courchbase server.

Requirements
------------

Attributes
----------

e.g.
#### couchbase::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['couchbase']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### couchbase::server

e.g.
Just include `couchbase` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[couchbase::server]"
  ]
}
```
