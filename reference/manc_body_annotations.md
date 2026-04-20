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
#>   [1] "status_user"                "group_old"                 
#>   [3] "subclassabbr"               "cluster_time"              
#>   [5] "soma_neuromere_user"        "predicted_nt_time"         
#>   [7] "source"                     "predicted_nt_prob_time"    
#>   [9] "position_user"              "soma_side"                 
#>  [11] "cluster_user"               "position_type_time"        
#>  [13] "to_review"                  "birthtime_time"            
#>  [15] "synonyms"                   "vfb_id_user"               
#>  [17] "soma_neuromere_time"        "bodyid"                    
#>  [19] "long_tract_time"            "naming_user_user"          
#>  [21] "vfb_id"                     "fru_dsx_time"              
#>  [23] "group_time"                 "confidence"                
#>  [25] "prefix"                     "old_bodyids"               
#>  [27] "source_time"                "user_time"                 
#>  [29] "vfb_id_time"                "neuropils_axonal_user"     
#>  [31] "group"                      "hemilineage"               
#>  [33] "serial_motif"               "nt_acetylcholine_prob"     
#>  [35] "nt_unknown_prob_time"       "systematic_type_user"      
#>  [37] "typing_notes_time"          "serial_motif_time"         
#>  [39] "avg_location"               "serial_time"               
#>  [41] "predicted_nt"               "description_user"          
#>  [43] "type_user"                  "entry_nerve_user"          
#>  [45] "prefix_user"                "predicted_nt_prob"         
#>  [47] "to_review_user"             "transmission_user"         
#>  [49] "entry_nerve_time"           "group_old_time"            
#>  [51] "reviewer_time"              "class_time"                
#>  [53] "old_bodyids_user"           "neuropils_axonal_time"     
#>  [55] "class_user"                 "root_position_time"        
#>  [57] "target"                     "position_time"             
#>  [59] "soma_neuromere"             "fru_dsx"                   
#>  [61] "predicted_nt_user"          "type"                      
#>  [63] "nt_glutamate_prob_user"     "old_bodyids_time"          
#>  [65] "nt_acetylcholine_prob_time" "origin_time"               
#>  [67] "group_user"                 "exit_nerve_time"           
#>  [69] "avg_location_time"          "tosoma_position"           
#>  [71] "exit_nerve"                 "birthtime_user"            
#>  [73] "position_type"              "prefix_time"               
#>  [75] "neuropils_dendritic_time"   "user"                      
#>  [77] "naming_user_time"           "subclass_time"             
#>  [79] "long_tract"                 "subcluster_time"           
#>  [81] "subclassabbr_user"          "tosoma_position_time"      
#>  [83] "soma_position_user"         "neuropils_axonal"          
#>  [85] "to_review_time"             "type_time"                 
#>  [87] "soma_side_user"             "position_type_user"        
#>  [89] "receptor_type"              "soma_side_time"            
#>  [91] "synonyms_user"              "modality_user"             
#>  [93] "class"                      "synonyms_time"             
#>  [95] "instance_time"              "systematic_type"           
#>  [97] "modality"                   "entry_nerve"               
#>  [99] "root_position_user"         "target_user"               
#> [101] "root_side_time"             "hemilineage_time"          
#> [103] "neuropils_dendritic"        "origin_user"               
#> [105] "transmission"               "origin"                    
#> [107] "status_time"                "exit_nerve_user"           
#> [109] "naming_user"                "transmission_time"         
#> [111] "user_user"                  "nt_gaba_prob_user"         
#> [113] "description_time"           "long_tract_user"           
#> [115] "nt_unknown_prob"            "group_old_user"            
#> [117] "serial_user"                "confidence_time"           
#> [119] "confidence_user"            "instance_user"             
#> [121] "subcluster"                 "modality_time"             
#> [123] "description"                "subclass"                  
#> [125] "root_position"              "tag_user"                  
#> [127] "hemilineage_user"           "root_side"                 
#> [129] "tag"                        "nt_gaba_prob_time"         
#> [131] "reviewer"                   "root_side_user"            
#> [133] "receptor_type_time"         "fru_dsx_user"              
#> [135] "tag_time"                   "target_time"               
#> [137] "serial"                     "tosoma_position_user"      
#> [139] "cluster"                    "receptor_type_user"        
#> [141] "predicted_nt_prob_user"     "typing_notes"              
#> [143] "reviewer_user"              "soma_position_time"        
#> [145] "position"                   "nt_glutamate_prob"         
#> [147] "soma_position"              "serial_motif_user"         
#> [149] "nt_acetylcholine_prob_user" "source_user"               
#> [151] "subclass_user"              "nt_gaba_prob"              
#> [153] "avg_location_user"          "nt_glutamate_prob_time"    
#> [155] "nt_unknown_prob_user"       "neuropils_dendritic_user"  
#> [157] "birthtime"                  "status"                    
#> [159] "systematic_type_time"       "subcluster_user"           
#> [161] "typing_notes_user"          "subclassabbr_time"         
#> [163] "instance"                  
```
