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
