# Package index

## General package functions

- [`malevnc`](https://natverse.org/malevnc/reference/malevnc-package.md)
  [`malevnc-package`](https://natverse.org/malevnc/reference/malevnc-package.md)
  : malevnc: Support for Working with Janelia FlyEM Male VNC Dataset
- [`dr_manc()`](https://natverse.org/malevnc/reference/dr_manc.md) :
  Status report for the malevnc package

## Server connections and Neuroglancer URLs

- [`choose_malevnc_dataset()`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.md)
  [`choose_flyem_dataset()`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.md)
  : Choose active male VNC / FlyEM dataset
- [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)
  : Login to MANC neuprint server
- [`manc_dvid_node()`](https://natverse.org/malevnc/reference/manc_dvid_node.md)
  [`manc_dvid_nodeinfo()`](https://natverse.org/malevnc/reference/manc_dvid_node.md)
  : Information about DVID nodes / return latest node
- [`manc_scene()`](https://natverse.org/malevnc/reference/manc_scene.md)
  : Return a Neuroglancer scene URL for MANC dataset
- [`dvid_tools()`](https://natverse.org/malevnc/reference/dvid_tools.md)
  [`install_dvid_tools()`](https://natverse.org/malevnc/reference/dvid_tools.md)
  : Interface to the python dvid_tools module from Philipp Schlegel
- [`flyem_shorten_url()`](https://natverse.org/malevnc/reference/flyem_shorten_url.md)
  [`flyem_expand_url()`](https://natverse.org/malevnc/reference/flyem_shorten_url.md)
  : Shorten a Neuroglancer URL using the Janelia FlyEM link shortener

## Body information and ids

- [`manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.md) :
  Flexible specification of manc body ids
- [`manc_xyz2bodyid()`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.md)
  : Find the bodyid for an XYZ location
- [`manc_islatest()`](https://natverse.org/malevnc/reference/manc_islatest.md)
  : Check if a bodyid still exists in the specified DVID node
- [`manc_size()`](https://natverse.org/malevnc/reference/manc_size.md) :
  Return the size (in voxels) of specified bodies
- [`manc_mutations()`](https://natverse.org/malevnc/reference/manc_mutations.md)
  : Get all the modifications associated with one or more DVID nodes
- [`manc_somapos()`](https://natverse.org/malevnc/reference/manc_somapos.md)
  [`manc_rootpos()`](https://natverse.org/malevnc/reference/manc_somapos.md)
  : Return the soma or root position of MANC bodyids

## Read annotations

- [`manc_body_annotations()`](https://natverse.org/malevnc/reference/manc_body_annotations.md)
  [`clio_fields()`](https://natverse.org/malevnc/reference/manc_body_annotations.md)
  : Return clio-store body annotations for set of ids or a flexible
  query
- [`manc_dvid_annotations()`](https://natverse.org/malevnc/reference/manc_dvid_annotations.md)
  : Return all DVID body annotations
- [`manc_point_annotations()`](https://natverse.org/malevnc/reference/manc_point_annotations.md)
  : Return point annotations from Clio store
- [`manc_meta()`](https://natverse.org/malevnc/reference/manc_meta.md) :
  Return full metadata from Clio/DVID for MANC bodyids (cached by
  default)
- [`manc_neuprint_meta()`](https://natverse.org/malevnc/reference/manc_neuprint_meta.md)
  : Fetch neuprint metadata for MANC neurons
- [`manc_user_annotations()`](https://natverse.org/malevnc/reference/manc_user_annotations.md)
  : Read point annotations from DVID using neuprint authentication
- [`clio_auth()`](https://natverse.org/malevnc/reference/clio_auth.md)
  [`clio_token()`](https://natverse.org/malevnc/reference/clio_auth.md)
  [`clio_set_token()`](https://natverse.org/malevnc/reference/clio_auth.md)
  : Clio authorisation infrastructure using Google via the gargle
  package + JWT

## Make annotations

- [`manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.md)
  : Set Clio body annotations
- [`manc_annotate_soma()`](https://natverse.org/malevnc/reference/manc_annotate_soma.md)
  : Annotate an XYZ location in Clio as a soma or root
- [`manc_set_lrgroup()`](https://natverse.org/malevnc/reference/manc_set_lrgroup.md)
  : Set Left-Right matching groups for neurons in DVID and optionally
  Clio
- [`manc_check_group_complete()`](https://natverse.org/malevnc/reference/manc_check_group_complete.md)
  : Check if group is complete
- [`manc_set_dvid_instance()`](https://natverse.org/malevnc/reference/manc_set_dvid_instance.md)
  [`manc_set_dvid_annotations()`](https://natverse.org/malevnc/reference/manc_set_dvid_instance.md)
  : Set DVID annotations for one or more ids.

## Connectivity

- [`manc_connection_table()`](https://natverse.org/malevnc/reference/manc_connection_table.md)
  : Convenience wrapper for neuprint connection queries for VNC dataset
- [`manc_leg_summary()`](https://natverse.org/malevnc/reference/manc_leg_summary.md)
  [`manc_side_summary()`](https://natverse.org/malevnc/reference/manc_leg_summary.md)
  : Simple summaries of which regions different neurons innervate

## Meshes, Skeletons and Geometry

- [`read_draco_meshes()`](https://natverse.org/malevnc/reference/read_manc_meshes.md)
  [`read_manc_meshes()`](https://natverse.org/malevnc/reference/read_manc_meshes.md)
  : Read draco encoded 3D meshes from tarballs (as used by Janelia
  FlyEM)
- [`manc_read_neurons()`](https://natverse.org/malevnc/reference/manc_read_neurons.md)
  : Read MANC skeletons via neuprint
- [`mirror_manc()`](https://natverse.org/malevnc/reference/mirror_manc.md)
  [`symmetric_manc()`](https://natverse.org/malevnc/reference/mirror_manc.md)
  : Mirror points or other 3D objects along the MANC midline
- [`manc_lr_position()`](https://natverse.org/malevnc/reference/manc_lr_position.md)
  : Calculate the left-right position wrt to the symmetrised MANC
  midline
- [`manc_view3d()`](https://natverse.org/malevnc/reference/manc_view3d.md)
  : Set a standard viewpoint for MANC data
- [`download_manc_registrations()`](https://natverse.org/malevnc/reference/download_manc_registrations.md)
  : Download MANC (EM) to JRC (light level) registrations

## Cartoon summaries

- [`colour_leg_muscles()`](https://natverse.org/malevnc/reference/colour_leg_muscles.md)
  [`leg_muscle_palette()`](https://natverse.org/malevnc/reference/colour_leg_muscles.md)
  : Create SVG figure with leg muscles coloured based on supplied colour
  palette

## Data objects

- [`mancneckseeds`](https://natverse.org/malevnc/reference/mancneckseeds.md)
  : Seed plane for the Neck Connective
- [`mancsomapos`](https://natverse.org/malevnc/reference/mancsomapos.md)
  : Soma locations for all intrinsic neurons of the ventral nerve cord
- [`MANC.surf`](https://natverse.org/malevnc/reference/MANC.surf.md)
  [`JRCFIBVNC2020MNP.surf`](https://natverse.org/malevnc/reference/MANC.surf.md)
  : Surface model of neuropils in the MANC dataset
- [`MANC.tissue.surf`](https://natverse.org/malevnc/reference/MANC.tissue.surf.md)
  [`MANC.tissue.surf.sym`](https://natverse.org/malevnc/reference/MANC.tissue.surf.md)
  [`MANC.nerves`](https://natverse.org/malevnc/reference/MANC.tissue.surf.md)
  : Simplified (and symmetrized) tissue surface of MALEVNC
- [`MANC.tracts`](https://natverse.org/malevnc/reference/MANC.tracts.md)
  : Meshes of 22 MALEVNC tracts.
- [`MANCsym`](https://natverse.org/malevnc/reference/MANCsym.md) : MANC
  symmetric template
