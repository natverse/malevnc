# malevnc 0.2.9
This is a major release providing support for the publication of the [MANC connectome]
(https://www.janelia.org/project-team/flyem/manc-connectome). We expect to bump
to v0.3 when all changes have stabilised.

* Feature/neuron units by @jefferis in https://github.com/natverse/malevnc/pull/60
* Feature/manc 1.0 by @jefferis in https://github.com/natverse/malevnc/pull/65
* improved support for JRC xforms by @jefferis in https://github.com/natverse/malevnc/pull/66
* Test/actionsv3 by @jefferis in https://github.com/natverse/malevnc/pull/67

# malevnc 0.2.8

* switch repo to natverse org preparing for public data release
* Add show.extra to manc_body_annotations 
* more options to exclude neuprint fields driven by the (temporary) addition of hundreds of new columns to the visual system for the male cns dataset. https://github.com/flyconnectome/malevnc/commit/0cb652aade1835d33f290e2a4a1bc7c3b9e1c2df
* Switch @dokato to author

# malevnc 0.2.7

## What's Changed
* Add `flyem_shorten_url()`, `flyem_expand_url()` by @jefferis in https://github.com/flyconnectome/malevnc/pull/54
* `manc_connection_table()` defaults to selected neuprint metadata
* `MANC.tracts` meshes object added by @dokato in https://github.com/flyconnectome/malevnc/pull/59
* Added `download_manc_registrations()` to download bridging registrations
  MANC <> JRC2018VNCU/M/F by @dokato in https://github.com/flyconnectome/malevnc/pull/58
* Add `colour_leg_muscles()` by @jefferis in https://github.com/flyconnectome/malevnc/pull/62

* New Clio query parsing (for `manc_annotate_body`) parametrized by @dokato in https://github.com/flyconnectome/malevnc/pull/55
  Also provides support for malecns annotation
* read `options(malevnc.dataset)` in `clio_version` (mostly for malecns)
* Critical fix to `clio_set_token()` by @dokato in https://github.com/flyconnectome/malevnc/pull/56
* fix bug in `manc_meta()` due to retired instance field by @jefferis in e6035ad31e7b3d75d7395079c6821d62a8933922
* Retire `manc_set_lrgroup()` We will now just set the group column directly
  via the clio interface. No need to use DVID / set instance values / sides etc.


**Full Changelog**: https://github.com/flyconnectome/malevnc/compare/v0.2.6...v0.2.7

# malevnc 0.2.6
## What's Changed
* New test store address by @dokato in https://github.com/flyconnectome/malevnc/pull/49
* More options added to manc scene by @dokato in https://github.com/flyconnectome/malevnc/pull/50
* ENH: force option added to clio_token by @dokato in https://github.com/flyconnectome/malevnc/pull/51
* Clio set token function added by @dokato in https://github.com/flyconnectome/malevnc/pull/52
* manc_get supports new Clio API by @dokato in https://github.com/flyconnectome/malevnc/pull/53

**Full Changelog**: https://github.com/flyconnectome/malevnc/compare/v0.2.3...v0.2.6
# malevnc 0.2.5

* Fix `manc_set_dvid_instance()` for >1 input ids

# malevnc 0.2.4

* update `manc_set_dvid_instance()` to cope with synonyms

# malevnc 0.2.3

* add `manc_view3d()` function with standard views based on symmetric MANC
  template.

# malevnc 0.2.2

* Factor out and export low level `manc_set_dvid_annotations()` function.
* Export `manc_set_dvid_instance()` and teach it to set instance/type and corresponding users for one or more body ids.


# malevnc 0.2.1
* Updated manc scene links by @dokato in https://github.com/flyconnectome/malevnc/pull/42
* Fix point annotation dataset (e.g. for use by malecns) by @jefferis in https://github.com/flyconnectome/malevnc/pull/44 


**Full Changelog**: https://github.com/flyconnectome/malevnc/compare/v0.2.0...v0.2.1

# malevnc 0.2.0

* WIP: simplified compute_clio_delta and remove NAs by @dokato in https://github.com/flyconnectome/malevnc/pull/30
* Add manc_leg_summary/manc_side_summary by @jefferis in https://github.com/flyconnectome/malevnc/pull/31
* Fix/dvid nodes by @jefferis in https://github.com/flyconnectome/malevnc/pull/32
* MANC nerve mesh added  by @dokato in https://github.com/flyconnectome/malevnc/pull/25
* Quck fix manc meta by @dokato in https://github.com/flyconnectome/malevnc/pull/33
* Fix handling of clio int64 bodyids by @jefferis in https://github.com/flyconnectome/malevnc/pull/34
* Feature/prepare mcns by @jefferis in https://github.com/flyconnectome/malevnc/pull/35
* don't update bodyids in manc meta by @jefferis in https://github.com/flyconnectome/malevnc/pull/39
* Use non-default oauth app when talking to google by @jefferis in https://github.com/flyconnectome/malevnc/pull/40


**Full Changelog**: https://github.com/flyconnectome/malevnc/compare/v0.1.2...v0.2.0

# malevnc 0.1.2
* updatebodyids - backward compatibility by @dokato in https://github.com/flyconnectome/malevnc/pull/27

**Full Changelog**: https://github.com/flyconnectome/malevnc/compare/v0.1.1...v0.1.2

# malevnc 0.1.1

## What's Changed
* Add support for reading clio store body annotations  by @jefferis in https://github.com/flyconnectome/malevnc/pull/3
* ellipsis passed to mirror_brain in mirror_manc by @dokato in https://github.com/flyconnectome/malevnc/pull/5
* manc tissue surface added by @dokato in https://github.com/flyconnectome/malevnc/pull/6
* handling missing values by @dokato in https://github.com/flyconnectome/malevnc/pull/7
* Use long-lived clio token by default by @jefferis in https://github.com/flyconnectome/malevnc/pull/9
* Fix/manc read neurons missing by @jefferis in https://github.com/flyconnectome/malevnc/pull/10
* Feature/clio annotate bodies by @jefferis in https://github.com/flyconnectome/malevnc/pull/14
* symmetrized tissue surface added by @dokato in https://github.com/flyconnectome/malevnc/pull/15
* randomise the id used for body annotation tests by @jefferis in https://github.com/flyconnectome/malevnc/pull/17
* Feature/new soma info by @jefferis in https://github.com/flyconnectome/malevnc/pull/18
* Update manc annotate body by @dokato in https://github.com/flyconnectome/malevnc/pull/19
* manc_set_lrgroup accepts partial changes by @dokato in https://github.com/flyconnectome/malevnc/pull/22
* Fixed dvidtools and tests added by @dokato in https://github.com/flyconnectome/malevnc/pull/24
* fix in manc_meta when setting dvid_group by @dokato in https://github.com/flyconnectome/malevnc/pull/26
* Added a `NEWS.md` file to track changes to the package.


**Full Changelog**: https://github.com/flyconnectome/malevnc/commits/v0.1.1

# malevnc 0.1

* first version
