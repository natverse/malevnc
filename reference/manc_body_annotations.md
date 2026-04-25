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
#>   [1] "reviewer_user"              "predicted_nt_user"         
#>   [3] "avg_location_time"          "type_user"                 
#>   [5] "predicted_nt_prob_user"     "typing_notes_user"         
#>   [7] "typing_notes_time"          "confidence"                
#>   [9] "neuropils_dendritic_time"   "nt_glutamate_prob_time"    
#>  [11] "neuropils_dendritic"        "instance"                  
#>  [13] "bodyid"                     "exit_nerve_user"           
#>  [15] "fru_dsx_user"               "predicted_nt_prob_time"    
#>  [17] "target_time"                "origin_time"               
#>  [19] "birthtime_user"             "group"                     
#>  [21] "naming_user"                "subclassabbr_time"         
#>  [23] "soma_side_user"             "neuropils_axonal_user"     
#>  [25] "subcluster"                 "nt_unknown_prob"           
#>  [27] "soma_neuromere_user"        "target"                    
#>  [29] "to_review_user"             "fru_dsx"                   
#>  [31] "serial_motif_user"          "description_user"          
#>  [33] "nt_glutamate_prob_user"     "position_type_user"        
#>  [35] "origin"                     "to_review_time"            
#>  [37] "long_tract_user"            "user"                      
#>  [39] "root_side_time"             "cluster_time"              
#>  [41] "nt_gaba_prob_time"          "group_old_time"            
#>  [43] "hemilineage_time"           "neuropils_axonal_time"     
#>  [45] "description_time"           "description"               
#>  [47] "nt_glutamate_prob"          "synonyms_user"             
#>  [49] "position_type_time"         "synonyms"                  
#>  [51] "old_bodyids_user"           "serial_motif_time"         
#>  [53] "soma_neuromere"             "exit_nerve"                
#>  [55] "entry_nerve_user"           "naming_user_user"          
#>  [57] "modality_user"              "entry_nerve"               
#>  [59] "soma_position_time"         "position_user"             
#>  [61] "group_user"                 "vfb_id"                    
#>  [63] "subclass_time"              "soma_side"                 
#>  [65] "reviewer_time"              "subcluster_time"           
#>  [67] "confidence_time"            "root_side"                 
#>  [69] "birthtime_time"             "target_user"               
#>  [71] "group_old_user"             "serial"                    
#>  [73] "soma_position_user"         "receptor_type_time"        
#>  [75] "instance_user"              "modality"                  
#>  [77] "tosoma_position"            "tosoma_position_time"      
#>  [79] "serial_time"                "position"                  
#>  [81] "predicted_nt_prob"          "class_user"                
#>  [83] "prefix_user"                "class"                     
#>  [85] "long_tract"                 "to_review"                 
#>  [87] "tag_time"                   "type"                      
#>  [89] "neuropils_axonal"           "typing_notes"              
#>  [91] "prefix_time"                "hemilineage"               
#>  [93] "naming_user_time"           "soma_side_time"            
#>  [95] "modality_time"              "systematic_type_time"      
#>  [97] "predicted_nt"               "fru_dsx_time"              
#>  [99] "vfb_id_time"                "reviewer"                  
#> [101] "nt_acetylcholine_prob"      "cluster"                   
#> [103] "confidence_user"            "group_old"                 
#> [105] "transmission_user"          "position_time"             
#> [107] "exit_nerve_time"            "subclassabbr_user"         
#> [109] "soma_position"              "cluster_user"              
#> [111] "user_user"                  "nt_acetylcholine_prob_user"
#> [113] "receptor_type_user"         "serial_user"               
#> [115] "source_time"                "prefix"                    
#> [117] "tag"                        "nt_unknown_prob_user"      
#> [119] "old_bodyids"                "root_position_user"        
#> [121] "vfb_id_user"                "synonyms_time"             
#> [123] "nt_unknown_prob_time"       "tag_user"                  
#> [125] "status"                     "root_side_user"            
#> [127] "status_user"                "birthtime"                 
#> [129] "origin_user"                "type_time"                 
#> [131] "transmission_time"          "instance_time"             
#> [133] "old_bodyids_time"           "predicted_nt_time"         
#> [135] "subcluster_user"            "subclassabbr"              
#> [137] "neuropils_dendritic_user"   "subclass_user"             
#> [139] "soma_neuromere_time"        "nt_gaba_prob"              
#> [141] "nt_acetylcholine_prob_time" "source"                    
#> [143] "source_user"                "user_time"                 
#> [145] "serial_motif"               "group_time"                
#> [147] "avg_location"               "systematic_type_user"      
#> [149] "systematic_type"            "root_position_time"        
#> [151] "transmission"               "class_time"                
#> [153] "tosoma_position_user"       "root_position"             
#> [155] "subclass"                   "avg_location_user"         
#> [157] "position_type"              "status_time"               
#> [159] "receptor_type"              "hemilineage_user"          
#> [161] "nt_gaba_prob_user"          "long_tract_time"           
#> [163] "entry_nerve_time"          
```
