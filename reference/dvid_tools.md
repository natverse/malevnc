# Interface to the python dvid_tools module from Philipp Schlegel

`dvid_tools` provides a lower level and less specific interface to DVID
that corresponding `manc_*` functions but does include some
functionality that is not yet available.

`install_dvid_tools` installs the python dvid_tools module

## Usage

``` r
dvid_tools(user = getOption("malevnc.dvid_user"), node = "neutu")

install_dvid_tools(pyinstall = "none")
```

## Arguments

- user:

  Default DVID user names

- node:

  default DVID node to use for queries (see
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md))

- pyinstall:

  whether to install python as well as the `dvidtools` package. Default
  none will not install.

## Details

The dvid_tools_module will be cached using `memoise`. You can modify the
default user with the \`\$setup\` method.

## See also

<https://github.com/flyconnectome/dvid_tools>,
<https://github.com/flyconnectome/dvid_tools>,
<https://emdata5.janelia.org/api/help/> for further details.

## Examples

``` r
if (FALSE) { # \dontrun{
dt=dvid_tools()
dt
# nb must explicity use integers for bodyids
dt$get_annotation(bodyid = 10000L)

# get detailed help
reticulate::py_help(dt$get_adjacency)
} # }
```
