# Return a Neuroglancer scene URL for MANC dataset

The default behaviour is to generate a rich neuroglancer scene with
including any passed `ids` using the current Clio DVID node. This means
that meshes should be in sync. See [this
slack](https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1619825198227100?thread_ts=1619816902.216600&cid=C01MYQ1AQ5D)
post from Stuart Berg for more details.

## Usage

``` r
manc_scene(
  ids = NULL,
  node = "clio",
  open = FALSE,
  show_synapse_layer = FALSE,
  show_sidebar = TRUE,
  shorten = FALSE,
  basescene = c("2022-04-13", "2022-01-13", "2021-05-05", "2021-05-04", "2021-04-01",
    "2021-02-01"),
  server = c("clio", "appspot", "janelia"),
  return.json = FALSE
)
```

## Arguments

- ids:

  A set of body ids to add to the neuroglancer scene in any form
  compatible with
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- node:

  A DVID node e.g. as returned by `manc_dvid_node`. The (recommended)
  default behaviour is to use the current Clio node.

- open:

  When `TRUE` opens the URL in your browser.

- show_synapse_layer:

  logical value that determines whether or not a synapse layer is
  visible by default

- show_sidebar:

  logical value that determines whether or not a sidebar is visible by
  default

- shorten:

  Whether to shorten the URL using the FlyEM URL shortener (see )

- basescene:

  Which neuroglancer scene url to use as a base. You can also supply
  your own URL.

- server:

  Whether to use Janelia's Clio branch, the Google server (newest
  version of neuroglancer) or the Janelia server (required for
  annotation in early 2021, but now deprecated in favour of Clio). 99
  should keep the default.

- return.json:

  Whether to return a JSON fragment defining the scene or (by default) a
  Neuroglancer URL.

## Value

A character vector containing a single Neuroglancer URL or a JSON
fragment.

## Details

Neuroglancer scenes can be pasted into a variety of different variants.
Use the `return.json` to get a JSON fragment that can be pasted into any
neuroglancer instance using the closed curly bracket symbol.

See
[slack](https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1624033684227400)
for why <https://clio-ng.janelia.org/> is the recommended base Url
(chosen when `server='clio'`).

## scenes

The following scenes (named by the approximate date that we started
using them) are available.

- `2022-04-13` Fixed synapses display and segmentation layer v.0.68.

- `2021-05-05` Like `2021-05-04` but with a voxelwise ROI segmentation
  layer copied over from `2021-04-01`.

- `2021-05-04` Added nerves and full VNC (cell body rind) surface mesh.
  See [Slack message from Stuart
  Berg](https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1620164087077600).
  GSXEJ added the ROIs to

- `2021-04-01` With VNC ROIs. By April 2021 we were using
  [Clio](https://clio.janelia.org/) for annotations.

- `2021-02-01` In early 2021 we were using a Janelia server hosting
  neuroglancer that allowed annotation through a hybrid DVID backend.

  The early 2021 server required authentication at
  <https://neuprint.janelia.org/> in order to use the annotation
  features. I recommend logging in and out of neuprint if you still get
  authentication errors from Neuroglancer when attempting to use the
  annotation layer.

## Examples

``` r
if (FALSE) { # \dontrun{
browseURL(manc_scene())
# copy scene information with a sample neuron to the clipboard
clipr::write_clip(manc_scene(ids=13749))

# JSON fragment that could be copied into Clio
clipr::write_clip(manc_scene(return.json = TRUE))

} # }
```
