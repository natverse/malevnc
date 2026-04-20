# Return clio-store body annotations for set of ids or a flexible query

`clio_fields` returns all the fields currently known to exist in the
clio store for a given dataset. A short description...

## Usage

``` r
manc_body_annotations(
  ids = NULL,
  query = NULL,
  json = FALSE,
  config = NULL,
  cache = FALSE,
  update.bodyids = FALSE,
  test = FALSE,
  show.extra = c("none", "user", "time", "all"),
  ...
)

clio_fields(dataset = getOption("malevnc.dataset"))
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- query:

  A json query string (see examples or documentation) or an R list with
  field names as elements.

- json:

  Whether to return unparsed JSON rather than an R list (default
  `FALSE`).

- config:

  An optional httr::config (expert use only, must include a bearer
  token)

- cache:

  Whether to cache the result of this call for 5 minutes.

- update.bodyids:

  Whether to update the bodyid associated with annotations based on the
  position field. The default value of this has been switched to `FALSE`
  as of Feb 2022.

- test:

  Whether to unset the clio-store test server (default `FALSE`)

- show.extra:

  Extra columns to show with user/timestamp information.

- ...:

  Additional arguments passed to
  [`pbapply::pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

- dataset:

  short name of the dataset (VNC or CNS)

## Value

An R data.frame or a character vector containing JSON (when
`json=TRUE`). Two additional fields will be added

- original.bodyid When `update.bodyids=TRUE` this field contains the
  original bodyid from Clio whereas `bodyid` contains the updated value
  implied by the position.

- `auto` `TRUE` signals that the record contains only data automatically
  copied over from DVID without any manual annotation.

  See
  [slack](https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1628214375055400)
  for details of the position / position type fields.

## Details

Missing values in each output column are filled with NA. But if a whole
column is missing from the results of a particular query then it will
not appear at all.

When neither `query` and `ids` are missing then we return all entries in
the clio store database. This currently includes annotations for all
body ids - even the ones that are no longer current.

## See also

[swagger docs](https://clio-store-vwzoicitea-uk.a.run.app/docs) or
[basic docs from Bill
Katz](https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit).

Other manc-annotation:
[`manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.md),
[`manc_meta()`](https://natverse.org/malevnc/reference/manc_meta.md),
[`manc_point_annotations()`](https://natverse.org/malevnc/reference/manc_point_annotations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
manc_body_annotations(ids=11442)
manc_body_annotations(ids=11442, show.extra='user')
manc_body_annotations(query='{"hemilineage": "0B"}')
manc_body_annotations(query=list(user="janedoe@gmail.com"))
manc_body_annotations(query=list(soma_side="RHS"))
manc_body_annotations(ids=manc_xyz2bodyid(mancneckseeds))
# use clio node to ensure for bodyid consistency
manc_body_annotations(ids=
  manc_xyz2bodyid(mancneckseeds, node="clio"))

# fetch all bodyids
mba=manc_body_annotations()
} # }
clio_fields()
#>   [1] "birthtime_time"             "fru_dsx_user"              
#>   [3] "nt_glutamate_prob_time"     "modality"                  
#>   [5] "nt_acetylcholine_prob"      "instance"                  
#>   [7] "prefix_user"                "group"                     
#>   [9] "tag"                        "soma_neuromere_user"       
#>  [11] "root_position_user"         "serial_motif_time"         
#>  [13] "group_old_time"             "nt_gaba_prob_time"         
#>  [15] "user"                       "tosoma_position_user"      
#>  [17] "avg_location"               "type_time"                 
#>  [19] "soma_position_time"         "predicted_nt_user"         
#>  [21] "receptor_type_user"         "serial_user"               
#>  [23] "receptor_type_time"         "systematic_type_user"      
#>  [25] "serial_motif_user"          "group_time"                
#>  [27] "confidence"                 "description_time"          
#>  [29] "cluster"                    "avg_location_time"         
#>  [31] "hemilineage_time"           "old_bodyids_time"          
#>  [33] "description"                "source"                    
#>  [35] "position_user"              "serial"                    
#>  [37] "soma_neuromere"             "root_side"                 
#>  [39] "class"                      "subcluster_time"           
#>  [41] "tosoma_position_time"       "long_tract_user"           
#>  [43] "transmission_time"          "neuropils_axonal_user"     
#>  [45] "systematic_type_time"       "root_side_time"            
#>  [47] "type_user"                  "confidence_time"           
#>  [49] "subclassabbr"               "reviewer"                  
#>  [51] "subclass_time"              "origin"                    
#>  [53] "entry_nerve"                "root_side_user"            
#>  [55] "reviewer_user"              "prefix"                    
#>  [57] "entry_nerve_time"           "soma_position"             
#>  [59] "birthtime_user"             "origin_time"               
#>  [61] "confidence_user"            "nt_gaba_prob"              
#>  [63] "naming_user_user"           "neuropils_axonal"          
#>  [65] "typing_notes"               "position_time"             
#>  [67] "exit_nerve_user"            "position"                  
#>  [69] "user_time"                  "hemilineage_user"          
#>  [71] "nt_unknown_prob_user"       "neuropils_dendritic"       
#>  [73] "subcluster"                 "to_review_time"            
#>  [75] "birthtime"                  "soma_position_user"        
#>  [77] "long_tract_time"            "exit_nerve_time"           
#>  [79] "group_old"                  "tosoma_position"           
#>  [81] "synonyms"                   "predicted_nt"              
#>  [83] "group_old_user"             "exit_nerve"                
#>  [85] "hemilineage"                "root_position_time"        
#>  [87] "nt_glutamate_prob"          "reviewer_time"             
#>  [89] "source_user"                "entry_nerve_user"          
#>  [91] "to_review"                  "nt_unknown_prob_time"      
#>  [93] "nt_gaba_prob_user"          "synonyms_time"             
#>  [95] "status_time"                "transmission_user"         
#>  [97] "neuropils_dendritic_time"   "soma_side_time"            
#>  [99] "class_time"                 "modality_user"             
#> [101] "target_time"                "cluster_user"              
#> [103] "position_type_user"         "transmission"              
#> [105] "fru_dsx_time"               "old_bodyids_user"          
#> [107] "neuropils_dendritic_user"   "target_user"               
#> [109] "vfb_id_user"                "predicted_nt_time"         
#> [111] "position_type_time"         "source_time"               
#> [113] "target"                     "nt_acetylcholine_prob_user"
#> [115] "user_user"                  "modality_time"             
#> [117] "group_user"                 "vfb_id"                    
#> [119] "subclass"                   "instance_user"             
#> [121] "subclassabbr_time"          "subcluster_user"           
#> [123] "to_review_user"             "typing_notes_user"         
#> [125] "status_user"                "nt_unknown_prob"           
#> [127] "receptor_type"              "subclass_user"             
#> [129] "old_bodyids"                "root_position"             
#> [131] "soma_neuromere_time"        "serial_motif"              
#> [133] "soma_side"                  "status"                    
#> [135] "cluster_time"               "neuropils_axonal_time"     
#> [137] "typing_notes_time"          "bodyid"                    
#> [139] "tag_time"                   "description_user"          
#> [141] "soma_side_user"             "nt_glutamate_prob_user"    
#> [143] "predicted_nt_prob"          "nt_acetylcholine_prob_time"
#> [145] "long_tract"                 "serial_time"               
#> [147] "type"                       "vfb_id_time"               
#> [149] "naming_user"                "synonyms_user"             
#> [151] "class_user"                 "origin_user"               
#> [153] "instance_time"              "subclassabbr_user"         
#> [155] "avg_location_user"          "predicted_nt_prob_time"    
#> [157] "position_type"              "prefix_time"               
#> [159] "fru_dsx"                    "systematic_type"           
#> [161] "predicted_nt_prob_user"     "naming_user_time"          
#> [163] "tag_user"                  
```
