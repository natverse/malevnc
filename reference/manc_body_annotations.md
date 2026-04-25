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
#>   [1] "target"                     "to_review_user"            
#>   [3] "synonyms"                   "nt_gaba_prob_user"         
#>   [5] "neuropils_axonal_time"      "predicted_nt"              
#>   [7] "entry_nerve_user"           "neuropils_dendritic_user"  
#>   [9] "class_time"                 "position_type_user"        
#>  [11] "soma_position_time"         "soma_side"                 
#>  [13] "subclass"                   "tosoma_position"           
#>  [15] "nt_gaba_prob_time"          "soma_side_user"            
#>  [17] "type_time"                  "serial_motif"              
#>  [19] "confidence_time"            "bodyid"                    
#>  [21] "serial_motif_time"          "naming_user_time"          
#>  [23] "class"                      "long_tract_time"           
#>  [25] "instance_time"              "old_bodyids_time"          
#>  [27] "vfb_id_user"                "origin_user"               
#>  [29] "group_time"                 "entry_nerve"               
#>  [31] "root_position"              "receptor_type_time"        
#>  [33] "status_user"                "source_time"               
#>  [35] "group_old"                  "systematic_type"           
#>  [37] "tosoma_position_time"       "subclass_time"             
#>  [39] "predicted_nt_prob_time"     "tosoma_position_user"      
#>  [41] "entry_nerve_time"           "target_time"               
#>  [43] "predicted_nt_prob_user"     "subclass_user"             
#>  [45] "modality_time"              "systematic_type_time"      
#>  [47] "soma_position"              "neuropils_dendritic_time"  
#>  [49] "type"                       "reviewer_user"             
#>  [51] "nt_acetylcholine_prob_user" "serial_motif_user"         
#>  [53] "root_position_time"         "nt_glutamate_prob_time"    
#>  [55] "class_user"                 "nt_unknown_prob"           
#>  [57] "description"                "old_bodyids_user"          
#>  [59] "confidence"                 "receptor_type"             
#>  [61] "avg_location"               "tag_user"                  
#>  [63] "old_bodyids"                "root_side_user"            
#>  [65] "source"                     "soma_neuromere"            
#>  [67] "reviewer_time"              "to_review"                 
#>  [69] "subclassabbr"               "position"                  
#>  [71] "group_old_time"             "exit_nerve_user"           
#>  [73] "root_side"                  "typing_notes_time"         
#>  [75] "transmission_time"          "position_user"             
#>  [77] "origin_time"                "tag_time"                  
#>  [79] "typing_notes_user"          "neuropils_axonal_user"     
#>  [81] "position_type"              "subcluster_time"           
#>  [83] "predicted_nt_prob"          "long_tract_user"           
#>  [85] "prefix"                     "hemilineage_user"          
#>  [87] "naming_user"                "modality_user"             
#>  [89] "birthtime"                  "instance"                  
#>  [91] "tag"                        "receptor_type_user"        
#>  [93] "cluster_time"               "vfb_id"                    
#>  [95] "prefix_user"                "source_user"               
#>  [97] "modality"                   "target_user"               
#>  [99] "soma_position_user"         "subcluster_user"           
#> [101] "subclassabbr_time"          "avg_location_user"         
#> [103] "synonyms_user"              "neuropils_axonal"          
#> [105] "soma_neuromere_user"        "group_user"                
#> [107] "nt_glutamate_prob_user"     "fru_dsx"                   
#> [109] "cluster_user"               "long_tract"                
#> [111] "exit_nerve"                 "hemilineage_time"          
#> [113] "cluster"                    "neuropils_dendritic"       
#> [115] "nt_unknown_prob_time"       "birthtime_time"            
#> [117] "typing_notes"               "nt_acetylcholine_prob_time"
#> [119] "description_time"           "exit_nerve_time"           
#> [121] "user_time"                  "confidence_user"           
#> [123] "subclassabbr_user"          "prefix_time"               
#> [125] "description_user"           "position_type_time"        
#> [127] "fru_dsx_user"               "group"                     
#> [129] "subcluster"                 "to_review_time"            
#> [131] "group_old_user"             "serial_user"               
#> [133] "fru_dsx_time"               "vfb_id_time"               
#> [135] "instance_user"              "reviewer"                  
#> [137] "user"                       "predicted_nt_time"         
#> [139] "birthtime_user"             "synonyms_time"             
#> [141] "serial"                     "user_user"                 
#> [143] "hemilineage"                "soma_neuromere_time"       
#> [145] "naming_user_user"           "transmission"              
#> [147] "systematic_type_user"       "origin"                    
#> [149] "soma_side_time"             "transmission_user"         
#> [151] "status"                     "avg_location_time"         
#> [153] "root_side_time"             "nt_glutamate_prob"         
#> [155] "position_time"              "serial_time"               
#> [157] "nt_acetylcholine_prob"      "nt_unknown_prob_user"      
#> [159] "nt_gaba_prob"               "predicted_nt_user"         
#> [161] "status_time"                "type_user"                 
#> [163] "root_position_user"        
```
