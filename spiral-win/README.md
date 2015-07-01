spiral-win Cookbook
===================

e.g.
This cookbook prepares windows machine for .NET projects. Contains recipes for preping winrm access and IIS setup.

Requirements
------------
Requires chef_handler and windows cookbooks.

e.g.
#### packages
- `windows` - spiral-win uses windows cookbook resources for ease of use for creating windows OS based resources.
- `chef_handler` - spiral-win needs chef_handler to be able to use chef windows handlers for errors and reports.

Attributes
----------
Disregard Attributes for the time being.
e.g.
#### spiral-win::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['spiral-win']['Test']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### spiral-win::default

e.g.
Just include `spiral-win`'s specific recipe in your node's `run_list`:

for Web Server with Winrm Support to be used for .net projects:
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[spiral-win::iis]", "recipe[spiral-win::winrm]", "recipe[spiral-win::dotnet]"
  ]
}
```

Contributing
------------

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
